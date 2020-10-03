import * as React from 'react';
import { useState } from 'react';
import { Theme, makeStyles, MenuItem } from '@material-ui/core';
import { useDispatch, useSelector } from 'react-redux';
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

import { selectAllCars } from '../../_store';
import { Car, Refueling } from '../../_models';
import { createRefueling, updateRefueling } from '../../_store/data';

interface StyleProps {
  closeButton: React.CSSProperties;
  marginNormal: React.CSSProperties;
}

type StyleClasses = Record<keyof StyleProps, string>;

const useStyles = makeStyles<Theme, StyleProps>(
  (theme: Theme) =>
    ({
      closeButton: {
        color: grey[400],
      },
      marginNormal: {
        marginTop: '16px',
        marginBottom: '8px',
      },
    } as any),
);

const margin = 'normal';

export interface RefuelingAddEditFormProps {
  refueling?: Refueling;
  open: boolean;
  handleClose: () => void;
}
export default function RefuelingAddEditForm(props: RefuelingAddEditFormProps) {
  const { refueling, open, handleClose } = props;

  const dispatch = useDispatch();
  const classes: StyleClasses = useStyles({} as StyleProps);

  const cars = useSelector(selectAllCars);

  let title = 'Create New Refueling';
  let actionText = 'Create';
  if (refueling) {
    title = 'Edit Refueling';
    actionText = 'Save';
  }

  const schema = Yup.object().shape({
    car: Yup.number().required('Required'),
    mileage: Yup.number().positive().required('Required'),
    date: Yup.date().max(new Date()).required('Required'),
    cost: Yup.number().positive().required('Required'),
    amount: Yup.number().positive().required('Required'),
  });

  const _handleSubmit = async (values: any) => {
    if (refueling) {
      await dispatch(
        updateRefueling({
          refueling: {
            id: Number(refueling.id),
            cost: values.cost,
            amount: values.amount,
            odomSnapshot: {
              id: refueling?.odomSnapshot?.id,
              car: values.car,
              date: new Date(values.date).toJSON(),
              mileage: values.mileage,
            },
          },
          snap: {
            id: refueling?.odomSnapshot?.id,
            car: values.car,
            date: new Date(values.date).toJSON(),
            mileage: values.mileage,
          },
        }),
      );
    } else {
      await dispatch(
        createRefueling({
          refueling: {
            cost: values.cost,
            amount: values.amount,
          },
          snap: {
            car: values.car,
            date: new Date(values.date).toJSON(),
            mileage: values.mileage,
          },
        }),
      );
    }
    handleClose();
  };

  return (
    <div>
      <Dialog
        open={open}
        onClose={handleClose}
        aria-labelledby="form-dialog-title"
      >
        <Formik
          initialValues={{
            car: refueling?.odomSnapshot?.car ?? '',
            mileage: refueling?.odomSnapshot?.mileage ?? '',
            date: refueling?.odomSnapshot?.date ?? new Date(),
            cost: refueling?.cost ?? '',
            amount: refueling?.amount ?? '',
          }}
          validationSchema={schema}
          onSubmit={_handleSubmit}
        >
          {({ submitForm, isSubmitting, status, errors, touched }) => (
            <>
              <DialogTitle id="form-dialog-title">{title}</DialogTitle>
              <DialogContent>
                <DialogContentText>
                  Add the information about the Refueling item here.
                </DialogContentText>
                <Form>
                  <div className={classes.marginNormal}>
                    <Field
                      component={Select}
                      name="car"
                      type="text"
                      label="Car"
                      variant="outlined"
                      error={touched.car && Boolean(errors.car)}
                      required
                      fullWidth
                    >
                      {cars?.map((c: Car) => (
                        <MenuItem key={c.id} value={c.id}>
                          {c.name}
                        </MenuItem>
                      ))}
                    </Field>
                  </div>
                  <Field
                    component={TextField}
                    name="mileage"
                    type="text"
                    label="Mileage"
                    variant="outlined"
                    margin="normal"
                    required
                    fullWidth
                  />
                  <Field
                    component={TextField}
                    name="date"
                    type="date"
                    label="Date"
                    variant="outlined"
                    margin="normal"
                    required
                    fullWidth
                    InputLabelProps={{ shrink: true }}
                  />
                  <Field
                    component={TextField}
                    name="cost"
                    type="number"
                    label="Cost"
                    variant="outlined"
                    margin="normal"
                    required
                    fullWidth
                  />
                  <Field
                    component={TextField}
                    name="amount"
                    type="number"
                    label="Fuel Amount"
                    variant="outlined"
                    margin="normal"
                    required
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
