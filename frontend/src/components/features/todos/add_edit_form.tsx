import * as React from 'react';
import { useState } from 'react';
import { Theme, makeStyles, MenuItem } from '@material-ui/core';
import { useDispatch, useSelector } from 'react-redux';
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

import { selectAllCars } from '../../_store';
import { Car, Todo } from '../../_models';
import { createTodo, updateTodo } from '../../_store/data';

interface StyleProps {
  closeButton: React.CSSProperties;
  dateRepeatSpacer: React.CSSProperties;
  errorText: React.CSSProperties;
  errorHelpText: React.CSSProperties;
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
      errorText: {
        color: theme.palette.error.light,
        marginBottom: 0,
      },
      errorHelpText: {
        color: theme.palette.error.light,
      },
    } as any),
);

const margin = 'normal';

export interface TodoAddEditFormProps {
  todo?: Todo;
  open: boolean;
  handleClose: () => void;
}
export default function TodoAddEditForm(props: TodoAddEditFormProps) {
  const { todo, open, handleClose } = props;
  const [name, setName] = useState(todo?.name || '');
  const [nameError, setNameError] = useState(false);
  const [car, setCar] = useState(todo?.car || 0);
  const [carError, setCarError] = useState(false);
  const [dueMileage, setDueMileage] = useState(todo?.dueMileage || 0);
  const [dueDate, setDueDate] = useState(todo?.dueDate || '');
  const [mileageRepeatInterval, setMileageRepeatInterval] = useState(
    todo?.mileageRepeatInterval || 0,
  );
  // TODO: translate data values to enum values here
  const [dateRepeatInterval, setDateRepeatInterval] = useState('never');
  const [addRequestStatus, setAddRequestStatus] = useState('idle');
  const [generalError, setGeneralError] = useState('');

  const dispatch = useDispatch();
  const classes: StyleClasses = useStyles({} as StyleProps);

  const cars = useSelector(selectAllCars);

  const onNameChanged = (e: React.ChangeEvent<HTMLInputElement>) =>
    setName(e.target.value);
  const onDueMileageChanged = (e: React.ChangeEvent<HTMLInputElement>) =>
    setDueMileage(Number(e.target.value));
  const onCarChanged = (e: React.ChangeEvent<HTMLInputElement>) =>
    setCar(Number(e.target.value));
  const onDueDateChanged = (e: React.ChangeEvent<HTMLInputElement>) =>
    setDueDate(e.target.value);
  const onMileageRepeatIntervalChanged = (
    e: React.ChangeEvent<HTMLInputElement>,
  ) => setMileageRepeatInterval(Number(e.target.value));
  const onDateRepeatIntervalChanged = (
    e: React.ChangeEvent<HTMLInputElement>,
  ) => setDateRepeatInterval(e.target.value);

  const canSave =
    [name, car].every(Boolean) &&
    (dueDate || dueMileage) &&
    addRequestStatus === 'idle';

  const onSaveTodoClicked = async () => {
    if (canSave) {
      try {
        setAddRequestStatus('pending');
        if (todo) {
          await dispatch(
            updateTodo({
              id: Number(todo.id),
              name: name,
              car: car,
              dueMileage: Number(dueMileage),
              dueDate: new Date(dueDate).toJSON(),
              mileageRepeatInterval: mileageRepeatInterval,
              completionOdomSnapshot: todo.completionOdomSnapshot,
              // TODO: below
              dateRepeatIntervalDays: 0,
              dateRepeatIntervalMonths: 0,
              dateRepeatIntervalYears: 0,
            }),
          );
        } else {
          await dispatch(
            createTodo({
              name: name,
              car: car,
              dueMileage: dueMileage,
              dueDate: new Date(dueDate).toJSON(),
              mileageRepeatInterval: mileageRepeatInterval,
              completionOdomSnapshot: null, // we get an error if this isn't present
              dateRepeatIntervalDays: 0,
              dateRepeatIntervalMonths: 0,
              dateRepeatIntervalYears: 0,
            }),
          );
        }
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
            {cars?.map((c: Car) => (
              <MenuItem key={c.id} value={c.id}>
                {c.name}
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
