import * as React from 'react';
import { useState } from 'react';
import { Theme, makeStyles } from '@material-ui/core';
import { useDispatch } from 'react-redux';
import Dialog from '@material-ui/core/Dialog';
import Button from '@material-ui/core/Button';
import DialogTitle from '@material-ui/core/DialogTitle';
import TextField from '@material-ui/core/TextField';
import DialogContent from '@material-ui/core/DialogContent';
import DialogContentText from '@material-ui/core/DialogContentText';
import DialogActions from '@material-ui/core/DialogActions';
import { grey } from '@material-ui/core/colors';

import { Car } from '../../_models';
import { createCar, createOdomSnapshot, updateCar } from '../../_store/data';

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

export interface CarAddEditFormProps {
  car?: Car;
  open: boolean;
  handleClose: () => void;
}
export default function CarAddEditForm(props: CarAddEditFormProps) {
  const { car, open, handleClose } = props;
  const [name, setName] = useState(car?.name || '');
  const [nameError, setNameError] = useState(false);
  const [odom, setOdom] = useState(car?.odom || 0);
  const [odomError, setOdomError] = useState(false);
  const [make, setMake] = useState(car?.make || '');
  const [model, setModel] = useState(car?.model || '');
  const [year, setYear] = useState(car?.year || '');
  const [plate, setPlate] = useState(car?.make || '');
  const [vin, setVin] = useState(car?.make || '');
  const [imageName, setImageName] = useState(car?.make || '');
  const [color, setColor] = useState(car?.color || null);

  const [addRequestStatus, setAddRequestStatus] = useState('idle');

  const dispatch = useDispatch();
  const classes: StyleClasses = useStyles({} as StyleProps);

  const onNameChanged = (e: React.ChangeEvent<HTMLInputElement>) =>
    setName(e.target.value);
  const onOdomChanged = (e: React.ChangeEvent<HTMLInputElement>) =>
    setOdom(Number(e.target.value));
  const onMakeChanged = (e: React.ChangeEvent<HTMLInputElement>) =>
    setMake(e.target.value);
  const onModelChanged = (e: React.ChangeEvent<HTMLInputElement>) =>
    setModel(e.target.value);
  const onYearChanged = (e: React.ChangeEvent<HTMLInputElement>) =>
    setYear(e.target.value);
  const onPlateChanged = (e: React.ChangeEvent<HTMLInputElement>) =>
    setPlate(e.target.value);
  const onVinChanged = (e: React.ChangeEvent<HTMLInputElement>) =>
    setVin(e.target.value);

  const canSave = [name].every(Boolean) && addRequestStatus === 'idle';

  const onSaveCarClicked = async () => {
    if (canSave) {
      try {
        setAddRequestStatus('pending');
        if (!color) {
          setColor(0); // TODO: set a random color from palette
        }
        if (car) {
          dispatch(
            updateCar({
              id: Number(car.id),
              name: name,
              make: make,
              model: model,
              year: year,
              plate: plate,
              vin: vin,
              imageName: imageName,
              color: color,
            }),
          );
          if (odom !== car.odom) {
            dispatch(
              createOdomSnapshot({
                date: new Date().toJSON(),
                mileage: odom,
                car: Number(car.id),
              }),
            );
          }
        } else {
          dispatch(
            createCar({
              car: {
                name: name,
                make: make,
                model: model,
                year: year,
                plate: plate,
                vin: vin,
                imageName: imageName,
                color: color,
              },
              snap: {
                date: new Date().toJSON(),
                mileage: odom,
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
      if (!name) {
        setNameError(true);
      }
    }
  };

  const onClose = () => {
    setNameError(false);
    setOdomError(false);
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
        <DialogTitle id="form-dialog-title">{title}</DialogTitle>
        <DialogContent>
          <DialogContentText>
            Add the information about the Car here.
          </DialogContentText>
          <TextField
            autoFocus
            margin={margin}
            id="name"
            label="Car Name *"
            type="text"
            fullWidth
            value={name}
            error={nameError ? true : undefined}
            helperText={nameError ? 'This field is required.' : undefined}
            onChange={onNameChanged}
          />
          <TextField
            margin={margin}
            id="odom"
            label="Mileage *"
            type="number"
            fullWidth
            value={odom}
            error={odomError ? true : undefined}
            helperText={odomError ? 'This field is required.' : undefined}
            onChange={onOdomChanged}
          />
          <TextField
            margin={margin}
            id="make"
            label="Make"
            type="text"
            fullWidth
            value={make}
            onChange={onMakeChanged}
          />
          <TextField
            margin={margin}
            id="model"
            label="Model"
            type="text"
            fullWidth
            value={model}
            onChange={onModelChanged}
          />
          <TextField
            margin={margin}
            id="year"
            label="Year"
            type="number"
            fullWidth
            value={year}
            onChange={onYearChanged}
          />
          <TextField
            margin={margin}
            id="plate"
            label="Plate"
            type="text"
            fullWidth
            value={plate}
            onChange={onPlateChanged}
          />
          <TextField
            margin={margin}
            id="vin"
            label="VIN"
            type="text"
            fullWidth
            value={vin}
            onChange={onVinChanged}
          />
          {/* TODO: not sure how to handle image and color pickers */}
        </DialogContent>
        <DialogActions>
          <Button onClick={onClose} className={classes.closeButton}>
            Cancel
          </Button>
          <Button onClick={onSaveCarClicked} color="primary">
            {actionText}
          </Button>
        </DialogActions>
      </Dialog>
    </div>
  );
}
