import * as React from 'react';
import { useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import {
  makeStyles,
  Theme,
  GridList,
  GridListTile,
  GridListTileBar,
  IconButton,
} from '@material-ui/core';
import StarBorderIcon from '@material-ui/icons/StarBorder';

import { selectAllCars, fetchData } from '../../_store';
import { RootState } from '../../store';
import { CarItem } from './item';

interface StyleProps {
  root: React.CSSProperties;
  gridList: React.CSSProperties;
  title: React.CSSProperties;
  titleBar: React.CSSProperties;
}

const useStyles = makeStyles<Theme, StyleProps>(
  (theme: Theme) =>
    ({
      root: {
        display: 'flex',
        flexWrap: 'wrap',
        justifyContent: 'space-around',
        overflow: 'hidden',
        // backgroundColor: theme.palette.background.paper,
      },
      gridList: {
        width: '100%',
        alignItems: 'flex-start',
        // flexWrap: 'nowrap',
        // Promote the list into his own layer on Chrome. This cost memory but helps keeping high FPS.
        transform: 'translateZ(0)',
        '& img': {
          width: '300px',
        },
      },
      title: {
        color: theme.palette.primary.light,
      },
      titleBar: {
        background:
          'linear-gradient(to top, rgba(0,0,0,0.7) 0%, rgba(0,0,0,0.3) 70%, rgba(0,0,0,0) 100%)',
      },
    } as any),
);

export const CarList = () => {
  const classes = useStyles({} as any);
  const dispatch = useDispatch();

  // const cars = useSelector(selectAllCars);
  const cars = [
    { id: 0, name: 'test1', color: 0, plate: 'L1C3NS3', odom: 2000 },
    { id: 1, name: 'test2', color: 0 },
    { id: 2, name: 'test2', color: 0 },
    { id: 3, name: 'test2', color: 0 },
  ];
  const carStatus = useSelector((state: RootState) => state.data.status);
  const error = useSelector((state: RootState) => state.data.error);

  useEffect(() => {
    if (carStatus === 'idle') {
      dispatch(fetchData());
    }
  }, [carStatus, dispatch]);

  const carItems = cars.map((c) => CarItem({ car: c }));

  return (
    <div className={classes.root}>
      <GridList className={classes.gridList} cols={3}>
        {cars.map((c) => (
          <CarItem car={c} />
        ))}
      </GridList>
    </div>
  );
};
