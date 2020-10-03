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
import FormControlLabel from '@material-ui/core/FormControlLabel';
import RadioGroup from '@material-ui/core/RadioGroup';
import Radio from '@material-ui/core/Radio';
import FormLabel from '@material-ui/core/FormLabel';
import { grey } from '@material-ui/core/colors';
import { Typography, LinearProgress, FormHelperText } from '@material-ui/core';
import { Formik, Form, Field } from 'formik';
import { TextField, Select } from 'formik-material-ui';

import { selectAllCars } from '../../_store';
import { Car, Todo } from '../../_models';
import { createTodo, updateTodo } from '../../_store/data';

interface StyleProps {
  closeButton: React.CSSProperties;
  dateRepeatSpacer: React.CSSProperties;
  marginNormal: React.CSSProperties;
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
      marginNormal: {
        marginTop: '16px',
        marginBottom: '8px',
      },
    } as any),
);

const margin = 'normal';

export interface TodoAddEditFormProps {
  todo?: Todo;
  open: boolean;
  handleClose: () => void;
}

interface FormFields {
  name?: string;
  car?: number | string;
  dueMileage?: number | string;
  dueDate?: Date | string;
  mileageRepeatInterval?: number | string;
  dateRepeatInterval?: string;
}

export default function TodoAddEditForm(props: TodoAddEditFormProps) {
  const { todo, open, handleClose } = props;

  const dispatch = useDispatch();
  const classes: StyleClasses = useStyles({} as StyleProps);

  const cars = useSelector(selectAllCars);

  let title = 'Create New Todo';
  let actionText = 'Create';
  if (todo) {
    title = 'Edit Todo';
    actionText = 'Save';
  }

  const _handleSubmit = async (values: any, actions: any) => {
    const request = {
      name: values.name,
      car: values.car,
      dueMileage: values.dueMileage,
      dueDate: new Date(values.dueDate).toJSON(),
      mileageRepeatInterval:
        values.mileageRepeatInterval === ''
          ? null
          : values.mileageRepeatInterval,
      completionOdomSnapshot: null, // we get an error if this isn't present
      dateRepeatIntervalDays: 0,
      dateRepeatIntervalMonths: 0,
      dateRepeatIntervalYears: 0,
    };
    try {
      if (todo) {
        await dispatch(
          updateTodo({
            completionOdomSnapshot: todo.completionOdomSnapshot,
            ...request,
          }),
        );
      } else {
        await dispatch(createTodo(request));
      }
      handleClose();
    } catch (err) {
      console.error('Failed to save the post: ', err);
    }
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
            name: '',
            car: '',
            mileage: '',
            date: '',
            mileageRepeatInterval: '',
            dateRepeatInterval: '',
          }}
          validate={(values) => {
            const errors: FormFields = {};

            if (!values.name) {
              errors.name = 'Required';
            }
            if (!values.car) {
              errors.car = 'Required';
            }
            if (!values.dueDate && !values.dueMileage) {
              errors.dueDate = 'A Due Date OR a Due Mileage is Required';
              errors.dueMileage = 'A Due Date OR a Due Mileage is Required';
            }
            if (values.dueMileage) {
              const carMileage = cars.find((c) => c.id === values.car)?.odom;
              if (carMileage && values.dueMileage < carMileage) {
                errors.dueMileage = `Due Mileage must be greater than Car Mileage (${carMileage})`;
              }
            }
            if (values.dueDate && values.dueDate < new Date()) {
              errors.dueDate = 'Due Date must be in the future';
            }
            if (values.mileageRepeatInterval === 0) {
              errors.mileageRepeatInterval =
                'Mileage Repeat Interval cannot be zero';
            }
            return errors;
          }}
          onSubmit={_handleSubmit}
        >
          {({ submitForm, isSubmitting, status, errors, touched }) => (
            <>
              <DialogTitle id="form-dialog-title">{title}</DialogTitle>
              <DialogContent>
                <DialogContentText>
                  Add the information about the Todo item here.
                </DialogContentText>
                <Form>
                  <Field
                    component={TextField}
                    name="name"
                    type="text"
                    label="Todo Name"
                    variant="outlined"
                    margin="normal"
                    required
                    fullWidth
                  />
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
                    <FormHelperText error={Boolean(errors.car)}>
                      {errors.car}
                    </FormHelperText>
                  </div>
                  <Field
                    component={TextField}
                    error={Boolean(errors.dueMileage)}
                    helperText={errors.dueMileage}
                    name="dueMileage"
                    type="number"
                    label="Due Mileage"
                    variant="outlined"
                    margin="normal"
                    fullWidth
                  />
                  <Field
                    component={TextField}
                    error={Boolean(errors.dueDate)}
                    helperText={errors.dueDate}
                    name="dueDate"
                    type="date"
                    label="Due Date"
                    variant="outlined"
                    margin="normal"
                    fullWidth
                    InputLabelProps={{ shrink: true }}
                  />
                  <Field
                    component={TextField}
                    name="mileageRepeatInterval"
                    type="number"
                    label="Mileage Repeat Interval"
                    variant="outlined"
                    margin="normal"
                    fullWidth
                  />
                  <div className={classes.dateRepeatSpacer} />
                  <FormLabel component="legend">Date Repeat Interval</FormLabel>
                  <Field
                    component={RadioGroup}
                    aria-label="Date Repeat Interval"
                    name="dateRepeatInterval"
                  >
                    <FormControlLabel
                      value="never"
                      control={<Radio size="small" />}
                      label="Never"
                    />
                    <FormControlLabel
                      value="weekly"
                      control={<Radio size="small" />}
                      label="Weekly"
                    />
                    <FormControlLabel
                      value="monthly"
                      control={<Radio size="small" />}
                      label="Monthly"
                    />
                    <FormControlLabel
                      value="yearly"
                      control={<Radio size="small" />}
                      label="Yearly"
                    />
                  </Field>
                  {isSubmitting && <LinearProgress />}
                  <Typography variant="body2" color="error">
                    {status}
                  </Typography>
                </Form>
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
