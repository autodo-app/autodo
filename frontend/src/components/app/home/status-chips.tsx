import * as React from 'react';
import { Theme, makeStyles } from '@material-ui/core';
import Chip from '@material-ui/core/Chip';
import { red, yellow } from '@material-ui/core/colors';

interface StyleProps {
  statusContainer: React.CSSProperties;
  late: React.CSSProperties;
  dueSoon: React.CSSProperties;
}

type StyleClasses = Record<keyof StyleProps, string>;

const useStyles = makeStyles<Theme, StyleProps>(
  (theme: Theme) =>
    ({
      statusContainer: {
        display: 'flex',
        justifyContent: 'center',
        width: '100px',
      },
      late: {
        backgroundColor: red[300],
        color: theme.palette.getContrastText(red[300]),
        marginTop: 'auto',
        marginBottom: 'auto',
        fontSize: '1.1rem',
        fontWeight: 600,
      },
      dueSoon: {
        backgroundColor: yellow[700],
        color: theme.palette.getContrastText(yellow[700]),
        marginTop: 'auto',
        marginBottom: 'auto',
        fontSize: '1.1rem',
        fontWeight: 600,
      },
    } as any),
);

export const LateChip = () => {
  const classes: StyleClasses = useStyles({} as StyleProps);

  return (
    <div className={classes.statusContainer}>
      <Chip label="Late" className={classes.late} />
    </div>
  );
};

export const DueSoonChip = () => {
  const classes: StyleClasses = useStyles({} as StyleProps);

  return (
    <div className={classes.statusContainer}>
      <Chip label="Due Soon" className={classes.dueSoon} />
    </div>
  );
};
