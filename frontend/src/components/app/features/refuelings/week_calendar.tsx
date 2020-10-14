import * as React from 'react';
import { startOfWeek, endOfWeek } from 'date-fns';
import { Theme, makeStyles } from '@material-ui/core';
import { eachDayOfInterval, isSameDay } from 'date-fns/esm';

import { Refueling } from '../../_models';
import { AUTODO_GREEN, GRAY } from '../../../theme';

interface StyleProps {
  root: React.CSSProperties;
  dayItem: React.CSSProperties;
  todayItem: React.CSSProperties;
  name: React.CSSProperties;
  number: React.CSSProperties;
  dot: React.CSSProperties;
  dotToday: React.CSSProperties;
  break: React.CSSProperties;
}

type StyleClasses = Record<keyof StyleProps, string>;

const useStyles = makeStyles<Theme, StyleProps>(
  (theme: Theme) =>
    ({
      root: {
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
      },
      dayItem: {
        padding: theme.spacing(1),
        display: 'flex',
        flexFlow: 'wrap',
        justifyContent: 'center',
      },
      todayItem: {
        padding: theme.spacing(1),
        display: 'flex',
        flexFlow: 'wrap',
        justifyContent: 'center',
        color: AUTODO_GREEN,
      },
      name: {
        width: '100%',
        margin: 'auto',
        textAlign: 'center',
        fontWeight: 500,
      },
      number: {
        margin: 'auto',
        fontWeight: 500,
        fontSize: '1.5rem',
      },
      break: {
        flexBasis: '100%',
        height: 0,
      },
      dot: {
        display: 'inline-block',
        margin: 'auto',
        backgroundColor: GRAY,
        width: '.5rem',
        height: '.5rem',
        borderRadius: '50%',
      },
      dotToday: {
        display: 'inline-block',
        margin: 'auto',
        backgroundColor: AUTODO_GREEN,
        width: '.5rem',
        height: '.5rem',
        borderRadius: '50%',
      },
    } as any),
);

const dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

interface WeekCalendarProps {
  refuelings: Refueling[];
}

export const WeekCalendar = (props: WeekCalendarProps) => {
  const { refuelings } = props;
  const classes: StyleClasses = useStyles({} as StyleProps);

  const today = new Date();
  const start = startOfWeek(today);
  const end = endOfWeek(today);
  const daysOfWeek = eachDayOfInterval({ start: start, end: end });

  const refuelingDates = refuelings.map(
    (r) => new Date(r?.odomSnapshot?.date ?? ''),
  );

  const dayItems = daysOfWeek.map((d: Date) => {
    const itemClass =
      d.getDay() === today.getDay() ? classes.todayItem : classes.dayItem;

    let dot = <></>;
    if (refuelingDates.some((r) => isSameDay(r, d))) {
      if (d.getDay() === today.getDay()) {
        dot = <div className={classes.dotToday} />;
      } else {
        dot = <div className={classes.dot} />;
      }
    }

    return (
      <div key={d.getDay()} className={itemClass}>
        <div className={classes.name}>{dayNames[d.getDay()]}</div>
        <div className={classes.number}>{d.getDate()}</div>
        <div className={classes.break} />
        {dot}
      </div>
    );
  });

  return <div className={classes.root}>{dayItems}</div>;
};
