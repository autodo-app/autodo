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

import theme from '../../theme';
import { Title, StyleClasses, StyleProps, useBaseStyles } from './shared';

const data = [{}];

export const DrivingRateChart = (): JSX.Element => {
  const classes: StyleClasses = useBaseStyles({} as StyleProps);
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
