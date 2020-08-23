import * as React from 'react';
import { Theme, makeStyles } from '@material-ui/core/styles';
import clsx from 'clsx';
import Grid from '@material-ui/core/Grid';
import Paper from '@material-ui/core/Paper';
import Container from '@material-ui/core/Container';
import { useSelector, useDispatch } from 'react-redux';

import { AUTODO_GREEN } from '../../theme';
import { FuelEfficiencyChart } from './fuelefficiencygraph';
import { FuelUsageByCar } from './fuelusagebycar';
import { DrivingRateChart } from './drivingrate';
import { FuelUsageChart } from './fuelusagebymonth';
import { selectAllCompletedTodos, selectAllRefuelings } from '../../_store';

interface StyleProps {
  root: React.CSSProperties;
  container: React.CSSProperties;
  fixedHeight: React.CSSProperties;
  paper: React.CSSProperties;
  labelText: React.CSSProperties;
  textHeight: React.CSSProperties;
  textStatContainer: React.CSSProperties;
  textStatText: React.CSSProperties;
  textStatNumber: React.CSSProperties;
}

type StyleClasses = Record<keyof StyleProps, string>;

const useStyles = makeStyles<Theme, StyleProps>(
  (theme: Theme) =>
    ({
      root: {
        flexGrow: 1,
        height: '100vh',
        overflow: 'auto',
      },
      container: {
        paddingLeft: 0,
        paddingRight: 0,
        paddingTop: theme.spacing(4),
        paddingBottom: theme.spacing(4),
      },
      paper: {
        padding: theme.spacing(2),
        display: 'flex',
        overflow: 'auto',
        flexDirection: 'column',
      },
      fixedHeight: {
        height: 344, // 80 + 240 + theme.spacing(3)
      },
      labelText: {
        fill: theme.palette.text.primary,
        textAnchor: 'middle',
      },
      textHeight: {
        height: 80,
      },
      textStatContainer: {
        height: '100%',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
      },
      textStatText: {
        padding: theme.spacing(1),
      },
      textStatNumber: {
        fontSize: 36,
        fontWeight: 800,
        color: AUTODO_GREEN,
        paddingLeft: theme.spacing(1),
      },
    } as any),
);

const CompletedTodos = (): JSX.Element => {
  const classes: StyleClasses = useStyles({} as StyleProps);
  const fixedHeightPaper = clsx(classes.paper, classes.textHeight);
  const todos = useSelector(selectAllCompletedTodos);

  return (
    <Grid item xs={12} md={6} lg={6}>
      <Paper className={fixedHeightPaper}>
        <div className={classes.textStatContainer}>
          <div className={classes.textStatText}>Total ToDos Completed:</div>
          <div className={classes.textStatNumber}>{todos.length}</div>
        </div>
      </Paper>
    </Grid>
  );
};

const LoggedRefuelings = (): JSX.Element => {
  const classes: StyleClasses = useStyles({} as StyleProps);
  const fixedHeightPaper = clsx(classes.paper, classes.textHeight);
  const refuelings = useSelector(selectAllRefuelings);

  return (
    <Grid item xs={12} md={6} lg={6}>
      <Paper className={fixedHeightPaper}>
        <div className={classes.textStatContainer}>
          <div className={classes.textStatText}>Total Refuelings Logged:</div>
          <div className={classes.textStatNumber}>{refuelings.length}</div>
        </div>
      </Paper>
    </Grid>
  );
};

export const StatsPage = (): JSX.Element => {
  const classes: StyleClasses = useStyles({} as StyleProps);
  // TODO: implement fuel efficiency, fuel usage, and driving rate on server side

  return (
    <div className={classes.root}>
      <Container maxWidth="lg" className={classes.container}>
        <Grid container spacing={3}>
          <FuelEfficiencyChart />
          <Grid item xs={12} md={6} lg={6}>
            <Grid container spacing={3}>
              <CompletedTodos />
              <LoggedRefuelings />
              <FuelUsageByCar />
            </Grid>
          </Grid>
          <DrivingRateChart />
          <FuelUsageChart />
        </Grid>
      </Container>
    </div>
  );
};
