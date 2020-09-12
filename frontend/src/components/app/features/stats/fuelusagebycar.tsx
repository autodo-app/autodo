import * as React from 'react';
import { useState } from 'react';
import { Theme, makeStyles } from '@material-ui/core/styles';
import clsx from 'clsx';
import Grid from '@material-ui/core/Grid';
import Paper from '@material-ui/core/Paper';
import { ResponsiveContainer, PieChart, Pie, Sector } from 'recharts';

import theme from '../../theme';
import { Title } from './shared';
import { FuelUsageCarData, Car } from '../../_models';

interface StyleProps {
  paper: React.CSSProperties;
  labelText: React.CSSProperties;
  fuelUsageHeight: React.CSSProperties;
  fuelUsageContainer: React.CSSProperties;
  fuelUsageChart: React.CSSProperties;
  fuelUsageTitle: React.CSSProperties;
}

type StyleClasses = Record<keyof StyleProps, string>;

const useStyles = makeStyles<Theme, StyleProps>(
  (theme: Theme) =>
    ({
      paper: {
        padding: theme.spacing(2),
        display: 'flex',
        overflow: 'auto',
        flexDirection: 'column',
      },
      labelText: {
        fill: theme.palette.text.primary,
        textAnchor: 'middle',
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

export interface PieData {
  name: string;
  value: number;
}

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

export interface FuelUsageByCarProps {
  data: FuelUsageCarData;
  cars: Car[];
}

export const FuelUsageByCar = (props: FuelUsageByCarProps): JSX.Element => {
  const { data, cars } = props;
  const classes: StyleClasses = useStyles({} as StyleProps);
  const fixedHeightPaper = clsx(classes.paper, classes.fuelUsageHeight);
  const [activeIndex, setActiveIndex] = useState(0);

  const onPieEnter = (data: any, index: any) => setActiveIndex(index);
  const pieData: PieData[] = [];
  for (const [k, v] of Object.entries(data)) {
    const car = cars.find((c) => c.id === parseInt(k));
    pieData.push({ name: car?.name ?? k, value: v });
  }

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
