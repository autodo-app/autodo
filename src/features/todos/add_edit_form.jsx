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
}));

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

export default function TodoAddEditForm({ open, handleClose }) {
  const [name, setName] = useState('');
  const [car, setCar] = useState(0);
  const [dueMileage, setDueMileage] = useState(0);
  const [dueDate, setDueDate] = useState(0);
  const [mileageRepeatInterval, setMileageRepeatInterval] = useState(0);
  const [dateRepeatInterval, setDateRepeatInterval] = useState('never');
  const [addRequestStatus, setAddRequestStatus] = useState('idle');

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

  const canSave = [name, car].every(Boolean) && addRequestStatus === 'idle';

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
    }
  };

  return (
    <div>
      <Dialog
        open={open}
        onClose={handleClose}
        aria-labelledby="form-dialog-title"
      >
        <DialogTitle id="form-dialog-title">Create New Todo</DialogTitle>
        <DialogContent>
          <DialogContentText>
            Add the information about the Todo item here.
          </DialogContentText>
          <TextField
            autoFocus
            margin="dense"
            id="name"
            label="Todo Name *"
            type="text"
            fullWidth
            defaultValue={name}
            onChange={onNameChanged}
          />
          <TextField
            select
            margin="dense"
            id="car"
            label="Car *"
            type="text"
            fullWidth
            onChange={onCarChanged}
          >
            {cars.map((c) => (
              <MenuItem key={c.value} value={c.value}>
                {c.label}
              </MenuItem>
            ))}
          </TextField>
          <TextField
            margin="dense"
            id="dueMileage"
            label="Due Mileage"
            type="number"
            fullWidth
            defaultValue={dueMileage}
            onChange={onDueMileageChanged}
          />
          <TextField
            margin="dense"
            id="dueDate"
            label="Due Date"
            type="date"
            fullWidth
            InputLabelProps={{ shrink: true }}
            onChange={onDueDateChanged}
          />
          <TextField
            margin="dense"
            id="mileageRepeatInterval"
            label="Mileage Repeat Interval"
            type="number"
            fullWidth
            defaultValue={mileageRepeatInterval}
            onChange={onMileageRepeatIntervalChanged}
          />
          <FormLabel component="legend">Date Repeat Interval</FormLabel>
          <RadioGroup
            aria-label="Date Repeat Interval"
            name="dateRepeatInterval"
            margin="dense"
            value={dateRepeatInterval}
            onChange={onDateRepeatIntervalChanged}
          >
            <FormControlLabel value="never" control={<Radio />} label="Never" />
            <FormControlLabel
              value="weekly"
              control={<Radio />}
              label="Weekly"
            />
            <FormControlLabel
              value="monthly"
              control={<Radio />}
              label="Monthly"
            />
            <FormControlLabel
              value="yearly"
              control={<Radio />}
              label="Yearly"
            />
          </RadioGroup>
        </DialogContent>
        <DialogActions>
          <Button onClick={handleClose} className={classes.closeButton}>
            Cancel
          </Button>
          <Button onClick={onSaveTodoClicked} color="primary">
            Create
          </Button>
        </DialogActions>
      </Dialog>
    </div>
  );
}
