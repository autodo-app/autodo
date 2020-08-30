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
import { DrivingRateData } from '../../_models';
import { Title, StyleClasses, StyleProps, useBaseStyles } from './shared';
import { useDispatch } from 'react-redux';

export interface DrivingRateChartProps {
  data: DrivingRateData;
}

export const DrivingRateChart = (props: DrivingRateChartProps): JSX.Element => {
  const { data } = props;
  const classes: StyleClasses = useBaseStyles({} as StyleProps);
  const dispatch = useDispatch();
  const fixedHeightPaper = clsx(classes.paper, classes.fixedHeight);

  return (
    <Grid item xs={12} md={6} lg={8}>
      <Paper className={fixedHeightPaper}>
        <Title>Driving Rate</Title>
        <ResponsiveContainer>
          <LineChart
            data={data['1']}
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
              dataKey="rate"
              stroke={theme.palette.primary.main}
              dot={false}
            />
          </LineChart>
        </ResponsiveContainer>
      </Paper>
    </Grid>
  );
};
