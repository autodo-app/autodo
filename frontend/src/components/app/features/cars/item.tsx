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
  const classes = useStyles({} as StyleProps);
  const { car } = props;
  return (
    <GridListTile key={car.id}>
      <Card className={classes.root}>
        <CardMedia
          className={classes.media}
          component="img"
          image="https://cyfairanimalhospital.com/wp-content/uploads/2018/12/blog_dragon-1.jpg"
          title="Contemplative Reptile"
        />
        <CardContent>
          <Typography gutterBottom variant="h5" component="h2" align="center">
            {car.name}
          </Typography>
          <Typography gutterBottom variant="body1" align="center">
            License: {car?.plate}
          </Typography>
          <Typography gutterBottom variant="body1" align="center">
            Odom: {car?.odom ?? '?'} mi
          </Typography>
        </CardContent>
        <CardActions>
          <Button size="small" color="primary">
            Edit
          </Button>
        </CardActions>
      </Card>
    </GridListTile>
  );
};
