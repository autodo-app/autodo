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
import { grey } from '@material-ui/core/colors';

import { selectAllCars } from '../../_store';
import { Car, Refueling } from '../../_models';
import { createRefueling, updateRefueling } from '../../_store/data';

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

export interface RefuelingAddEditFormProps {
  refueling?: Refueling;
  open: boolean;
  handleClose: () => void;
}
export default function RefuelingAddEditForm(props: RefuelingAddEditFormProps) {
  const { refueling, open, handleClose } = props;
  const [car, setCar] = useState(refueling?.odomSnapshot?.car ?? 0);
  const [carError, setCarError] = useState(false);
  const [date, setDate] = useState(refueling?.odomSnapshot?.date ?? '');
  const [mileage, setMileage] = useState(refueling?.odomSnapshot?.mileage ?? 0);
  const [mileageError, setMileageError] = useState(false);
  const [cost, setCost] = useState(refueling?.cost || 0);
  const [costError, setCostError] = useState(false);
  const [amount, setAmount] = useState(refueling?.amount || 0);
  const [amountError, setAmountError] = useState(false);

  const [addRequestStatus, setAddRequestStatus] = useState('idle');

  const dispatch = useDispatch();
  const classes: StyleClasses = useStyles({} as StyleProps);

  const cars = useSelector(selectAllCars);

  const onCarChanged = (e: React.ChangeEvent<HTMLInputElement>) =>
    setCar(Number(e.target.value));
  const onDateChanged = (e: React.ChangeEvent<HTMLInputElement>) =>
    setDate(e.target.value);
  const onMileageChanged = (e: React.ChangeEvent<HTMLInputElement>) =>
    setMileage(Number(e.target.value));
  const onAmountChanged = (e: React.ChangeEvent<HTMLInputElement>) =>
    setAmount(Number(e.target.value));
  const onCostChanged = (e: React.ChangeEvent<HTMLInputElement>) =>
    setCost(Number(e.target.value));

  const canSave = [car].every(Boolean) && addRequestStatus === 'idle';

  const onSaveRefuelingClicked = async () => {
    if (canSave) {
      try {
        setAddRequestStatus('pending');
        if (!date) {
          setDate(new Date().toJSON());
        }
        if (refueling) {
          await dispatch(
            updateRefueling({
              refueling: {
                id: Number(refueling.id),
                cost: cost,
                amount: amount,
              },
              snap: {
                car: car,
                date: new Date(date).toJSON(),
                mileage: mileage,
              },
            }),
          );
        } else {
          await dispatch(
            createRefueling({
              refueling: {
                cost: cost,
                amount: amount,
              },
              snap: {
                car: car,
                date: new Date(date).toJSON(),
                mileage: mileage,
              },
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
      if (!car) {
        setCarError(true);
      }
      if (!mileage) {
        setMileageError(true);
      }
      if (!cost) {
        setCostError(true);
      }
      if (!amount) {
        setAmountError(true);
      }
    }
  };

  const onClose = () => {
    setCarError(false);
    handleClose();
  };

  let title = 'Create New Refueling';
  let actionText = 'Create';
  if (refueling) {
    title = 'Edit Refueling';
    actionText = 'Save';
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
            Add the information about the Refueling item here.
          </DialogContentText>
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
            {cars.map((c: Car) => (
              <MenuItem key={c.id} value={c.id}>
                {c.name}
              </MenuItem>
            ))}
          </TextField>
          <TextField
            margin={margin}
            id="mileage"
            label="Mileage *"
            type="number"
            fullWidth
            value={mileage}
            error={mileageError ? true : undefined}
            helperText={mileageError ? 'This field is required.' : undefined}
            onChange={onMileageChanged}
          />
          <TextField
            margin={margin}
            id="date"
            label="Date"
            type="date"
            fullWidth
            InputLabelProps={{ shrink: true }}
            onChange={onDateChanged}
          />
          <TextField
            margin={margin}
            id="cost"
            label="Cost *"
            type="number"
            fullWidth
            value={cost}
            error={costError ? true : undefined}
            helperText={costError ? 'This field is required.' : undefined}
            onChange={onCostChanged}
          />
          <TextField
            margin={margin}
            id="amount"
            label="amount *"
            type="number"
            fullWidth
            value={amount}
            error={amountError ? true : undefined}
            helperText={amountError ? 'This field is required.' : undefined}
            onChange={onAmountChanged}
          />
        </DialogContent>
        <DialogActions>
          <Button onClick={onClose} className={classes.closeButton}>
            Cancel
          </Button>
          <Button onClick={onSaveRefuelingClicked} color="primary">
            {actionText}
          </Button>
        </DialogActions>
      </Dialog>
    </div>
  );
}
