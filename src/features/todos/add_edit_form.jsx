import React, { useState } from 'react';
import { makeStyles, MenuItem } from '@material-ui/core';
import { useDispatch } from 'react-redux';
import { unwrapResult } from '@reduxjs/toolkit';
import Dialog from '@material-ui/core/Dialog';
import Button from '@material-ui/core/Button';
import DialogTitle from '@material-ui/core/DialogTitle';
import TextField from '@material-ui/core/TextField';
import DialogContent from '@material-ui/core/DialogContent';
import DialogContentText from '@material-ui/core/DialogContentText';
import DialogActions from '@material-ui/core/DialogActions';
import FormControlLabel from '@material-ui/core/FormControlLabel';
import RadioGroup from '@material-ui/core/RadioGroup';
import Radio from '@material-ui/core/Radio';
import FormLabel from '@material-ui/core/FormLabel';
import { grey } from '@material-ui/core/colors';

import { addNewTodo } from '../../_slices';

const useStyles = makeStyles((theme) => ({
  closeButton: {
    color: grey[400],
  },
  dateRepeatSpacer: {
    height: '1rem',
  },
  errorText: {
    color: theme.palette.error.light,
    marginBottom: 0,
  },
  errorHelpText: {
    color: theme.palette.error.light,
  },
}));

const margin = 'normal';

const cars = [
  {
    value: '1',
    label: 'car1',
  },
  {
    value: '2',
    label: 'car2',
  },
];

export default function TodoAddEditForm({ todo, open, handleClose }) {
  const [name, setName] = useState(todo?.name || '');
  const [nameError, setNameError] = useState(false);
  const [car, setCar] = useState(todo?.car || 0);
  const [carError, setCarError] = useState(false);
  const [dueMileage, setDueMileage] = useState(todo?.dueMileage || 0);
  const [dueDate, setDueDate] = useState(todo?.dueDate || '');
  const [mileageRepeatInterval, setMileageRepeatInterval] = useState(
    todo?.mileageRepeatInterval || 0,
  );
  const [dateRepeatInterval, setDateRepeatInterval] = useState(
    todo?.dateRepeatInterval || 'never',
  );
  const [addRequestStatus, setAddRequestStatus] = useState('idle');
  const [generalError, setGeneralError] = useState('');

  const dispatch = useDispatch();
  const classes = useStyles();

  const onNameChanged = (e) => setName(e.target.value);
  const onDueMileageChanged = (e) => setDueMileage(e.target.value);
  const onCarChanged = (e) => setCar(e.target.value);
  const onDueDateChanged = (e) => setDueDate(e.target.value);
  const onMileageRepeatIntervalChanged = (e) =>
    setMileageRepeatInterval(e.target.value);
  const onDateRepeatIntervalChanged = (e) =>
    setDateRepeatInterval(e.target.value);

  const canSave =
    [name, car].every(Boolean) &&
    (dueDate || dueMileage) &&
    addRequestStatus === 'idle';

  const onSaveTodoClicked = async () => {
    if (canSave) {
      try {
        setAddRequestStatus('pending');
        const resultAction = await dispatch(
          addNewTodo({
            name: name,
            car: car,
            dueMileage: dueMileage,
          }),
        );
        unwrapResult(resultAction);
        setName('');
        setCar(0);
        setDueMileage(0);
      } catch (err) {
        console.error('Failed to save the post: ', err);
      } finally {
        setAddRequestStatus('idle');
      }
      handleClose();
    } else {
      if (!name) {
        setNameError(true);
      }
      if (!car) {
        setCarError(true);
      }
      if (!(dueDate || dueMileage)) {
        setGeneralError(
          'Either a Due Mileage or Due Date needs to be specified.',
        );
      }
    }
  };

  const onClose = () => {
    setNameError(false);
    setCarError(false);
    setGeneralError('');
    handleClose();
  };

  let title = 'Create New Todo';
  let actionText = 'Create';
  if (todo) {
    title = 'Edit Todo';
    actionText = 'Save';
  }

  let errorText = <></>;
  if (generalError) {
    errorText = <h4 className={classes.errorText}>{generalError}</h4>;
  }

  return (
    <div>
      <Dialog
        open={open}
        onClose={handleClose}
        aria-labelledby="form-dialog-title"
      >
        <DialogTitle id="form-dialog-title">{title}</DialogTitle>
        <DialogContent>
          <DialogContentText>
            Add the information about the Todo item here.
          </DialogContentText>
          <TextField
            autoFocus
            margin={margin}
            id="name"
            label="Todo Name *"
            type="text"
            fullWidth
            value={name}
            error={nameError ? true : undefined}
            helperText={nameError ? 'This field is required.' : undefined}
            onChange={onNameChanged}
          />
          <TextField
            select
            margin={margin}
            id="car"
            label="Car *"
            type="text"
            fullWidth
            value={car}
            error={carError ? true : undefined}
            helperText={carError ? 'This field is required.' : undefined}
            onChange={onCarChanged}
          >
            {cars.map((c) => (
              <MenuItem key={c.value} value={c.value}>
                {c.label}
              </MenuItem>
            ))}
          </TextField>
          <TextField
            margin={margin}
            id="dueMileage"
            label="Due Mileage"
            type="number"
            fullWidth
            value={dueMileage}
            error={generalError ? true : undefined}
            onChange={onDueMileageChanged}
          />
          <TextField
            margin={margin}
            id="dueDate"
            label="Due Date"
            type="date"
            fullWidth
            InputLabelProps={{ shrink: true }}
            error={generalError ? true : undefined}
            onChange={onDueDateChanged}
          />
          <TextField
            margin={margin}
            id="mileageRepeatInterval"
            label="Mileage Repeat Interval"
            type="number"
            fullWidth
            defaultValue={mileageRepeatInterval}
            onChange={onMileageRepeatIntervalChanged}
          />
          <div className={classes.dateRepeatSpacer} />
          <FormLabel component="legend">Date Repeat Interval</FormLabel>
          <RadioGroup
            aria-label="Date Repeat Interval"
            name="dateRepeatInterval"
            margin={margin}
            value={dateRepeatInterval}
            onChange={onDateRepeatIntervalChanged}
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
          </RadioGroup>
          {errorText}
        </DialogContent>
        <DialogActions>
          <Button onClick={onClose} className={classes.closeButton}>
            Cancel
          </Button>
          <Button onClick={onSaveTodoClicked} color="primary">
            {actionText}
          </Button>
        </DialogActions>
      </Dialog>
    </div>
  );
}
