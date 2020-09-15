import * as React from 'react';
import clsx from 'clsx';
import Grid from '@material-ui/core/Grid';
import Paper from '@material-ui/core/Paper';
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  Label,
  ResponsiveContainer,
} from 'recharts';

import theme from '../../../theme';
import { FuelUsageMonthData } from '../../_models';
import { Title, StyleClasses, StyleProps, useBaseStyles } from './shared';

export interface FuelUsageChartProps {
  data: FuelUsageMonthData;
}

export const FuelUsageChart = (props: FuelUsageChartProps): JSX.Element => {
  const { data } = props;
  const classes: StyleClasses = useBaseStyles({} as StyleProps);
  const fixedHeightPaper = clsx(classes.paper, classes.fixedHeight);

  return (
    <Grid item xs={12} md={6} lg={4}>
      <Paper className={fixedHeightPaper}>
        <Title>Fuel Usage Per Month</Title>
        <ResponsiveContainer>
          <BarChart
            data={data['1']}
            margin={{ top: 16, right: 16, bottom: 0, left: 24 }}
          >
            <XAxis dataKey="date" stroke={theme.palette.text.secondary} />
            <YAxis stroke={theme.palette.text.secondary}>
              <Label angle={270} position="left" className={classes.labelText}>
                Gallons
              </Label>
            </YAxis>
            <Bar
              dataKey="amount"
              fill={theme.palette.primary.main}
              barSize={15}
            />
          </BarChart>
          {/* <LineChart
            data={[]}
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
          </LineChart> */}
        </ResponsiveContainer>
      </Paper>
    </Grid>
  );
};
