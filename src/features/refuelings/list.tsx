import * as React from 'react';
import { useEffect } from 'react';
import { Theme, makeStyles } from '@material-ui/core';
import { Divider } from '@material-ui/core';
import { useSelector, useDispatch } from 'react-redux';

import RefuelingItem from './item';
import { selectAllRefuelings, fetchData } from '../../_store';
import { RootState } from '../../app/store';

interface StyleProps {
  header: React.CSSProperties;
  dashboard: React.CSSProperties;
  date: React.CSSProperties;
  dateNumber: React.CSSProperties;
  upcoming: React.CSSProperties;
  statusMessage: React.CSSProperties;
}

type StyleClasses = Record<keyof StyleProps, string>;

const useStyles = makeStyles<Theme, StyleProps>(
  (theme: Theme) =>
    ({
      header: {
        display: 'flex',
        justifyContent: 'space-between',
      },
      dashboard: {
        marginTop: '1.5rem',
        marginBottom: '.25rem',
      },
      date: {
        marginTop: '1.5rem',
        marginBottom: '.25rem',
        fontWeight: '400',
        letterSpacing: 0.8,
      },
      dateNumber: {
        fontWeight: '600',
        letterSpacing: 0.8,
      },
      upcoming: {
        fontWeight: '400',
        letterSpacing: 0.8,
        marginBottom: '.25rem',
      },
      statusMessage: {
        display: 'flex',
        margin: theme.spacing(2),
        alignContent: 'center',
        justifyContent: 'center',
      },
    } as any),
);

export const RefuelingList: React.FC<{}> = (): JSX.Element => {
  const classes: StyleClasses = useStyles({} as StyleProps);
  const dispatch = useDispatch();

  const refuelings = useSelector(selectAllRefuelings);
  const refuelingStatus = useSelector((state: RootState) => state.data.status);
  const error = useSelector((state: RootState) => state.data.error);

  useEffect(() => {
    if (refuelingStatus === 'idle') {
      dispatch(fetchData());
    }
  }, [refuelingStatus, dispatch]);

  if (refuelingStatus === 'loading') {
    return <div className={classes.statusMessage}>Loading...</div>;
  } else if (refuelingStatus === 'error') {
    return <div className={classes.statusMessage}>{error}</div>;
  }

  const refuelingItems = refuelings.map((r) => <RefuelingItem refueling={r} />);

  return (
    <>
      <div className={classes.header}>
        <h2 className={classes.dashboard}>Refuelings</h2>
        <h4 className={classes.date}>
          Wednesday, <span className={classes.dateNumber}>July 29th</span>
        </h4>
      </div>
      <Divider />

      {refuelingItems}
    </>
  );
};
