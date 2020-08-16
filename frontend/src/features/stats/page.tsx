import * as React from 'react';
import { Theme, makeStyles } from '@material-ui/core/styles';
import clsx from 'clsx';
import Grid from '@material-ui/core/Grid';
import Paper from '@material-ui/core/Paper';
import Container from '@material-ui/core/Container';
import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  Label,
  ResponsiveContainer,
} from 'recharts';
import theme from '../../theme';
import { Typography } from '@material-ui/core';

interface StyleProps {
  root: React.CSSProperties;
  container: React.CSSProperties;
  fixedHeight: React.CSSProperties;
  paper: React.CSSProperties;
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
        height: 240,
      },
    } as any),
);

interface TitleProps {
  children: string;
}

const Title = (props: TitleProps): JSX.Element => (
  <Typography
    component="h2"
    variant="h6"
    color="primary"
    align="center"
    gutterBottom
  >
    {props.children}
  </Typography>
);

const data = [
  { time: '00:00', amount: 0 },
  { time: '03:00', amount: 300 },
  { time: '06:00', amount: 600 },
  { time: '09:00', amount: 800 },
  { time: '12:00', amount: 1500 },
  { time: '15:00', amount: 2000 },
  { time: '18:00', amount: 2400 },
  { time: '21:00', amount: 2400 },
  { time: '24:00', amount: undefined },
];

const FuelEfficiencyChart = (): JSX.Element => {
  const classes: StyleClasses = useStyles({} as StyleProps);
  const fixedHeightPaper = clsx(classes.paper, classes.fixedHeight);

  return (
    <Grid item xs={12} md={6} lg={6}>
      <Paper className={fixedHeightPaper}>
        <Title>Fuel Efficiency</Title>
        <ResponsiveContainer>
          <LineChart
            data={data}
            margin={{ top: 16, right: 16, bottom: 0, left: 24 }}
          >
            <XAxis dataKey="time" stroke={theme.palette.text.secondary} />
            <YAxis stroke={theme.palette.text.secondary}>
              <Label
                angle={270}
                position="left"
                style={{
                  textAnchor: 'middle',
                  file: theme.palette.text.primary,
                }}
              >
                Sales ($)
              </Label>
            </YAxis>
            <Line
              type="monotone"
              dataKey="amount"
              stroke={theme.palette.primary.main}
              dot={false}
            />
          </LineChart>
        </ResponsiveContainer>
      </Paper>
    </Grid>
  );
};

const CompletedTodos = (): JSX.Element => {
  const classes: StyleClasses = useStyles({} as StyleProps);

  return (
    <Grid item xs={12} md={6} lg={6}>
      <Paper className={classes.paper}>
        <p>
          Total ToDos Completed: <span>24</span>
        </p>
      </Paper>
    </Grid>
  );
};

const LoggedRefuelings = (): JSX.Element => {
  const classes: StyleClasses = useStyles({} as StyleProps);

  return (
    <Grid item xs={12} md={6} lg={6}>
      <Paper className={classes.paper}>
        <p>
          Total Refuelings Logged: <span>24</span>
        </p>
      </Paper>
    </Grid>
  );
};

const FuelUsageByCar = (): JSX.Element => {
  const classes: StyleClasses = useStyles({} as StyleProps);

  return (
    <Grid item xs={12} md={12} lg={12}>
      <Paper className={classes.paper}>
        <p>Usage by Car</p>
      </Paper>
    </Grid>
  );
};

const DrivingRateChart = (): JSX.Element => {
  const classes: StyleClasses = useStyles({} as StyleProps);
  const fixedHeightPaper = clsx(classes.paper, classes.fixedHeight);

  return (
    <Grid item xs={12} md={6} lg={8}>
      <Paper className={fixedHeightPaper}>
        <Title>Driving Rate</Title>
        <ResponsiveContainer>
          <LineChart
            data={data}
            margin={{ top: 16, right: 16, bottom: 0, left: 24 }}
          >
            <XAxis dataKey="time" stroke={theme.palette.text.secondary} />
            <YAxis stroke={theme.palette.text.secondary}>
              <Label
                angle={270}
                position="left"
                style={{
                  textAnchor: 'middle',
                  file: theme.palette.text.primary,
                }}
              >
                Sales ($)
              </Label>
            </YAxis>
            <Line
              type="monotone"
              dataKey="amount"
              stroke={theme.palette.primary.main}
              dot={false}
            />
          </LineChart>
        </ResponsiveContainer>
      </Paper>
    </Grid>
  );
};

const FuelUsageChart = (): JSX.Element => {
  const classes: StyleClasses = useStyles({} as StyleProps);
  const fixedHeightPaper = clsx(classes.paper, classes.fixedHeight);

  return (
    <Grid item xs={12} md={6} lg={4}>
      <Paper className={fixedHeightPaper}>
        <Title>Fuel Usage Per Month</Title>
        <ResponsiveContainer>
          <LineChart
            data={data}
            margin={{ top: 16, right: 16, bottom: 0, left: 24 }}
          >
            <XAxis dataKey="time" stroke={theme.palette.text.secondary} />
            <YAxis stroke={theme.palette.text.secondary}>
              <Label
                angle={270}
                position="left"
                style={{
                  textAnchor: 'middle',
                  file: theme.palette.text.primary,
                }}
              >
                Sales ($)
              </Label>
            </YAxis>
            <Line
              type="monotone"
              dataKey="amount"
              stroke={theme.palette.primary.main}
              dot={false}
            />
          </LineChart>
        </ResponsiveContainer>
      </Paper>
    </Grid>
  );
};

export const StatsPage = (): JSX.Element => {
  const classes: StyleClasses = useStyles({} as StyleProps);

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
