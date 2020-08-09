import * as React from 'react';
import { useEffect } from 'react';
import { Theme, makeStyles } from '@material-ui/core';
import { Divider } from '@material-ui/core';
import { useSelector, useDispatch } from 'react-redux';

import RefuelingItem from './item';
import { selectAllRefuelings, fetchData } from '../../_store';
import { RootState } from '../../app/store';
import { GRAY } from '../../theme';

interface StyleProps {
  header: React.CSSProperties;
  dashboard: React.CSSProperties;
  date: React.CSSProperties;
  dateNumber: React.CSSProperties;
  upcoming: React.CSSProperties;
  statusMessage: React.CSSProperties;
  separator: React.CSSProperties;
  separatorContainer: React.CSSProperties;
  spacer: React.CSSProperties;
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
      separatorContainer: {
        display: 'flex',
        width: `calc(1.5rem + ${theme.spacing(2)}px)`,
        paddingLeft: theme.spacing(1),
        paddingRight: theme.spacing(1),
      },
      separator: {
        width: '5px',
        height: '1.25rem',
        borderRadius: '3px',
        backgroundColor: GRAY,
        margin: 'auto',
        alignSelf: 'center',
        justifyContent: 'center',
      },
      spacer: {
        height: theme.spacing(1),
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

  const refuelingItems = refuelings.map((r, idx) => {
    const separator =
      idx === refuelings.length - 1 ? (
        <div />
      ) : (
        <>
          <div className={classes.separatorContainer}>
            <div className={classes.separator} />
          </div>
        </>
      );
    return (
      <>
        <RefuelingItem first={idx === 0} refueling={r} />
        {separator}
      </>
    );
  });

  return (
    <>
      <div className={classes.header}>
        <h2 className={classes.dashboard}>Refuelings</h2>
        <h4 className={classes.date}>
          Wednesday, <span className={classes.dateNumber}>July 29th</span>
        </h4>
      </div>
      <Divider />
      <div className={classes.spacer} />
      {refuelingItems}
    </>
  );
};
