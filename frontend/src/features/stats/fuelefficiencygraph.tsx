import * as React from 'react';
import { Theme, makeStyles } from '@material-ui/core/styles';
import clsx from 'clsx';
import Grid from '@material-ui/core/Grid';
import Paper from '@material-ui/core/Paper';
import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  Label,
  ResponsiveContainer,
} from 'recharts';

import theme, { AUTODO_GREEN, BACKGROUND_DARK } from '../../theme';
import { Title, StyleClasses, StyleProps, useBaseStyles } from './shared';
import { EfficiencyDot } from './efficiencydot';

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

const fetchData = () => {
  return data;
};

export const FuelEfficiencyChart = (): JSX.Element => {
  const classes: StyleClasses = useBaseStyles({} as StyleProps);
  const fixedHeightPaper = clsx(classes.paper, classes.fixedHeight);
  const data = fetchData();

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
