import * as React from 'react';
import { useState } from 'react';
import { Theme, makeStyles } from '@material-ui/core';
import { useDispatch } from 'react-redux';
import Dialog from '@material-ui/core/Dialog';
import Button from '@material-ui/core/Button';
import DialogTitle from '@material-ui/core/DialogTitle';
import DialogContent from '@material-ui/core/DialogContent';
import DialogContentText from '@material-ui/core/DialogContentText';
import DialogActions from '@material-ui/core/DialogActions';
import { grey } from '@material-ui/core/colors';
import { LinearProgress } from '@material-ui/core';
import { Formik, Form, Field } from 'formik';
import { TextField, Select } from 'formik-material-ui';
import * as Yup from 'yup';

import { Car } from '../../_models';
import { createCar, createOdomSnapshot, updateCar } from '../../_store/data';

interface StyleProps {
  closeButton: React.CSSProperties;
  dateRepeatSpacer: React.CSSProperties;
}

type StyleClasses = Record<keyof StyleProps, string>;

const useStyles = makeStyles<Theme, StyleProps>(
  (theme: Theme) =>
    ({
      closeButton: {
        color: grey[400],
      },
      dateRepeatSpacer: {
        height: '1rem',
      },
    } as any),
);

export interface CarAddEditFormProps {
  car?: Car;
  open: boolean;
  handleClose: () => void;
}
export default function CarAddEditForm(props: CarAddEditFormProps) {
  const { car, open, handleClose } = props;

  const dispatch = useDispatch();
  const classes: StyleClasses = useStyles({} as StyleProps);

  const schema = Yup.object().shape({
    name: Yup.string().required('Required'),
    odom: Yup.number().integer().positive().required('Required'),
    make: Yup.string(),
    model: Yup.string(),
    year: Yup.number().positive().integer().max(new Date().getFullYear()),
    plate: Yup.string(),
    vin: Yup.string(),
  });

  const _handleSubmit = (values: any) => {
    const request = {
      name: values.name,
      make: values.make,
      model: values.model,
      year:
        typeof values.year === 'number' ? values.year : parseInt(values.year),
      plate: values.plate,
      vin: values.plate,
      color: 0,
      snaps: [
        {
          date: new Date().toJSON(),
          mileage: values.odom,
        },
      ],
    };
    if (car) {
      dispatch(
        updateCar({
          id: Number(car.id),
          ...request,
        }),
      );
    } else {
      dispatch(createCar(request));
    }
    handleClose();
  };

  let title = 'Create New Car';
  let actionText = 'Create';
  if (car) {
    title = 'Edit Car';
    actionText = 'Save';
  }

  return (
    <div>
      <Dialog
        open={open}
        onClose={handleClose}
        aria-labelledby="form-dialog-title"
      >
        <Formik
          initialValues={{
            name: car?.name ?? '',
            odom: car?.odom ?? '',
            make: car?.make ?? '',
            model: car?.model ?? '',
            year: car?.year ?? '',
            plate: car?.plate ?? '',
            vin: car?.vin ?? '',
          }}
          validationSchema={schema}
          onSubmit={_handleSubmit}
        >
          {({ submitForm, isSubmitting }) => (
            <>
              <DialogTitle id="form-dialog-title">{title}</DialogTitle>
              <DialogContent>
                <DialogContentText>
                  Add the information about the Car here.
                </DialogContentText>
                <Form>
                  <Field
                    component={TextField}
                    name="name"
                    type="text"
                    label="Name"
                    variant="outlined"
                    required
                    margin="normal"
                    fullWidth
                  />
                  <Field
                    component={TextField}
                    name="odom"
                    type="number"
                    label="Mileage"
                    variant="outlined"
                    required
                    margin="normal"
                    fullWidth
                  />
                  <Field
                    component={TextField}
                    name="make"
                    type="text"
                    label="Make"
                    variant="outlined"
                    margin="normal"
                    fullWidth
                  />
                  <Field
                    component={TextField}
                    name="model"
                    type="text"
                    label="Model"
                    variant="outlined"
                    margin="normal"
                    fullWidth
                  />
                  <Field
                    component={TextField}
                    name="year"
                    type="number"
                    label="Year"
                    variant="outlined"
                    margin="normal"
                    fullWidth
                  />
                  <Field
                    component={TextField}
                    name="plate"
                    type="text"
                    label="Plate"
                    variant="outlined"
                    margin="normal"
                    fullWidth
                  />
                  <Field
                    component={TextField}
                    name="vin"
                    type="text"
                    label="VIN"
                    variant="outlined"
                    margin="normal"
                    fullWidth
                  />
                </Form>
                {isSubmitting && <LinearProgress />}
              </DialogContent>
              <DialogActions>
                <Button onClick={handleClose} className={classes.closeButton}>
                  Cancel
                </Button>
                <Button onClick={submitForm} color="primary">
                  {actionText}
                </Button>
              </DialogActions>
            </>
          )}
        </Formik>
      </Dialog>
    </div>
  );
}
