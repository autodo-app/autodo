import * as React from 'react';
import { useState } from 'react';
import { useDispatch } from 'react-redux';
import {
  makeStyles,
  Theme,
  GridListTile,
  Card,
  CardMedia,
  CardContent,
  Typography,
  CardActions,
  Button,
} from '@material-ui/core';

import { Car } from '../../_models';
import { AUTODO_GREEN, BACKGROUND_DARK, GRAY } from '../../../theme';
import CarAddEditForm from './add_edit_form';

interface StyleProps {
  root: React.CSSProperties;
  media: React.CSSProperties;
}

const useStyles = makeStyles<Theme, StyleProps>(
  (theme: Theme) =>
    ({
      root: {
        width: 'inherit',
        minWidth: 100,
        maxWidth: 250,
        height: 340,
        marginTop: '3rem',
        marginBottom: '3rem',
        marginLeft: '0',
        marginRight: '2rem',
      },
      media: {
        height: '140px',
      },
    } as any),
);

export interface CarItemProps {
  car: Car;
}

export const CarItem: React.FC<CarItemProps> = (props): JSX.Element => {
  const { car } = props;
  const classes = useStyles({} as any);

  const [open, setOpen] = useState(false);
  const onClick = () => setOpen(true);
  const handleClose = () => setOpen(false);

  return (
    <>
      <GridListTile key={car?.id ?? 0}>
        <Card className={classes.root}>
          <CardMedia
            className={classes.media}
            component="img"
            image="https://lh3.googleusercontent.com/proxy/ydK84wW8qtQnULtrCq1nd-tVmzffewOuR5txsdsB_Ro_C7tWgW-z5yY18jh2aCZmzLa33hqw7RFGp8Ye4Yt7af4lm2CMzaxWNH0SUX50FKjJEaDeWFqb18lnPwH3sEBNnd0Lzfvai5bCNYX2hL4rrw"
            title="Car"
          />
          <CardContent>
            <Typography gutterBottom variant="h5" component="h2" align="center">
              {car?.name ?? 'blank'}
            </Typography>
            <Typography gutterBottom variant="body1" align="center">
              License: {car?.plate}
            </Typography>
            <Typography gutterBottom variant="body1" align="center">
              Odom: {car?.odom ?? '?'} mi
            </Typography>
          </CardContent>
          <CardActions>
            <Button size="small" color="primary" onClick={onClick}>
              Edit
            </Button>
          </CardActions>
        </Card>
      </GridListTile>
      <CarAddEditForm car={car} open={open} handleClose={handleClose} />
    </>
  );
};