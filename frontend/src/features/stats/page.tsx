import * as React from 'react';
import { useState } from 'react';
import { Theme, makeStyles } from '@material-ui/core/styles';
import clsx from 'clsx';
import { Typography } from '@material-ui/core';
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
  PieChart,
  Pie,
  Sector,
  Cell,
} from 'recharts';
import theme, { AUTODO_GREEN, BACKGROUND_DARK } from '../../theme';
import { EfficiencyDot } from './efficiencydot';

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
  fuelUsageHeight: React.CSSProperties;
  fuelUsageContainer: React.CSSProperties;
  fuelUsageChart: React.CSSProperties;
  fuelUsageTitle: React.CSSProperties;
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
      fuelUsageHeight: {
        height: 240,
      },
      fuelUsageContainer: {
        height: '100%',
      },
      fuelUsageChart: {
        alignSelf: 'stretch',
      },
      fuelUsageTitle: {
        alignSelf: 'center',
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
  { time: '00:00', amount: 0, average: 0 },
  { time: '03:00', amount: 300, average: 250 },
  { time: '06:00', amount: 600, average: 630 },
  { time: '09:00', amount: 800, average: 900 },
  { time: '12:00', amount: 1500, average: 1230 },
  { time: '15:00', amount: 2000, average: 1900 },
  { time: '18:00', amount: 2400, average: 2560 },
  { time: '21:00', amount: 2400, average: 2300 },
  { time: '24:00', amount: undefined, average: undefined },
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
              <Label angle={270} position="left" className={classes.labelText}>
                MPG
              </Label>
            </YAxis>
            <Line
              type="monotone"
              dataKey="amount"
              stroke={theme.palette.primary.main}
              dot={false}
            />
            <Line
              type="monotone"
              dataKey="average"
              stroke="rgba(0,0,0,0)"
              dot={<EfficiencyDot data={data} />}
            />
          </LineChart>
        </ResponsiveContainer>
      </Paper>
    </Grid>
  );
};

const CompletedTodos = (): JSX.Element => {
  const classes: StyleClasses = useStyles({} as StyleProps);
  const fixedHeightPaper = clsx(classes.paper, classes.textHeight);

  return (
    <Grid item xs={12} md={6} lg={6}>
      <Paper className={fixedHeightPaper}>
        <div className={classes.textStatContainer}>
          <div className={classes.textStatText}>Total ToDos Completed:</div>
          <div className={classes.textStatNumber}>24</div>
        </div>
      </Paper>
    </Grid>
  );
};

const LoggedRefuelings = (): JSX.Element => {
  const classes: StyleClasses = useStyles({} as StyleProps);
  const fixedHeightPaper = clsx(classes.paper, classes.textHeight);

  return (
    <Grid item xs={12} md={6} lg={6}>
      <Paper className={fixedHeightPaper}>
        <div className={classes.textStatContainer}>
          <div className={classes.textStatText}>Total Refuelings Logged:</div>
          <div className={classes.textStatNumber}>24</div>
        </div>
      </Paper>
    </Grid>
  );
};

interface PieData {
  name: string;
  value: number;
}

const pieData = [
  { name: 'Group A', value: 400 },
  { name: 'Group B', value: 300 },
  { name: 'Group C', value: 300 },
  { name: 'Group D', value: 200 },
];

interface RenderActiveShapeProps {
  cx: number;
  cy: number;
  midAngle: number;
  innerRadius: number;
  outerRadius: number;
  startAngle: number;
  endAngle: number;
  fill: string;
  payload: PieData;
  percent: number;
  value: number;
}

const renderActiveShape = (props: RenderActiveShapeProps) => {
  const RADIAN = Math.PI / 180;
  const {
    cx,
    cy,
    midAngle,
    innerRadius,
    outerRadius,
    startAngle,
    endAngle,
    fill,
    payload,
    percent,
    value,
  } = props;
  const sin = Math.sin(-RADIAN * midAngle);
  const cos = Math.cos(-RADIAN * midAngle);
  const sx = cx + (outerRadius + 5) * cos;
  const sy = cy + (outerRadius + 5) * sin;
  const mx = cx + (outerRadius + 20) * cos;
  const my = cy + (outerRadius + 20) * sin;
  const ex = mx + (cos >= 0 ? 1 : -1) * 6;
  const ey = my;
  const textAnchor = cos >= 0 ? 'start' : 'end';

  return (
    <g>
      <text x={cx} y={cy} dy={8} textAnchor="middle" fill={fill}>
        {payload.name}
      </text>
      <Sector
        cx={cx}
        cy={cy}
        innerRadius={innerRadius}
        outerRadius={outerRadius}
        startAngle={startAngle}
        endAngle={endAngle}
        fill={fill}
      />
      <Sector
        cx={cx}
        cy={cy}
        startAngle={startAngle}
        endAngle={endAngle}
        innerRadius={outerRadius + 3}
        outerRadius={outerRadius + 5}
        fill={fill}
      />
      <path
        d={`M${sx},${sy}L${mx},${my}L${ex},${ey}`}
        stroke={fill}
        fill="none"
      />
      <circle cx={ex} cy={ey} r={2} fill={fill} stroke="none" />
      <text
        x={ex + (cos >= 0 ? 1 : -1) * 6}
        y={ey}
        textAnchor={textAnchor}
        fill={theme.palette.text.primary}
      >
        {value}
      </text>
    </g>
  );
};

const FuelUsageByCar = (): JSX.Element => {
  const classes: StyleClasses = useStyles({} as StyleProps);
  const fixedHeightPaper = clsx(classes.paper, classes.fuelUsageHeight);
  const [activeIndex, setActiveIndex] = useState(0);

  const onPieEnter = (data: any, index: any) => setActiveIndex(index);

  return (
    <Grid item xs={12} md={12} lg={12}>
      <Paper className={fixedHeightPaper}>
        <Grid container className={classes.fuelUsageContainer}>
          <Grid item xs={12} md={4} lg={4} className={classes.fuelUsageTitle}>
            <Title>Fuel Usage by Car</Title>
          </Grid>
          <Grid item xs={12} md={8} lg={8} className={classes.fuelUsageChart}>
            <ResponsiveContainer>
              <PieChart>
                <Pie
                  activeIndex={activeIndex}
                  activeShape={renderActiveShape}
                  data={pieData}
                  dataKey="value"
                  innerRadius={50}
                  outerRadius={60}
                  fill="#8884d8"
                  onMouseEnter={onPieEnter}
                />
              </PieChart>
            </ResponsiveContainer>
          </Grid>
        </Grid>
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
              <Label angle={270} position="left" className={classes.labelText}>
                Miles per Day
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
              <Label angle={270} position="left" className={classes.labelText}>
                Gallons
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
