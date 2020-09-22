import * as React from 'react';
import { useState } from 'react';
import { useDispatch } from 'react-redux';
import {
  makeStyles,
  Theme,
  GridListTile,
  Card,
  CardContent,
} from '@material-ui/core';

import { Car } from '../../_models';
import { AUTODO_GREEN, BACKGROUND_DARK, GRAY } from '../../../theme';

interface StyleProps {
  root: React.CSSProperties;
  filler: React.CSSProperties;
}

const useStyles = makeStyles<Theme, StyleProps>(
  (theme: Theme) =>
    ({
      filler: {
        width: '200px',
        height: '100px',
        margin: '2rem',
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
      <Card className={classes.filler}>
        <CardContent>
          <p>{car.name}</p>
          {/* <img src="/" />
            <GridListTileBar
              title={c.name}
              classes={{ root: classes.titleBar, title: classes.title }}
              actionIcon={
                <IconButton aria-label={`star ${c.name}`}>
                  <StarBorderIcon className={classes.title} />
                </IconButton>
              }
            ></GridListTileBar> */}
        </CardContent>
      </Card>
    </GridListTile>
  );
};
