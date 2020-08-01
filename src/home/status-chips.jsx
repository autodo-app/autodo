import React from 'react';
import { makeStyles } from '@material-ui/core';
import Chip from '@material-ui/core/Chip';
import { red, yellow } from '@material-ui/core/colors';

const useStyles = makeStyles((theme) => ({
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
}));

export const LateChip = () => {
  const classes = useStyles();

  return (
    <div className={classes.statusContainer}>
      <Chip label="Late" className={classes.late} />
    </div>
  );
};

export const DueSoonChip = () => {
  const classes = useStyles();

  return (
    <div className={classes.statusContainer}>
      <Chip label="Due Soon" className={classes.dueSoon} />
    </div>
  );
};
