import * as React from 'react';
import { useEffect } from 'react';
import { useSelector, useDispatch } from 'react-redux';
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
import { selectFuelEfficiencyData, fetchStats } from '../../_store';
import { RootState } from '../../app/store';
import { Title, StyleClasses, StyleProps, useBaseStyles } from './shared';
import { EfficiencyDot } from './efficiencydot';

export const FuelEfficiencyChart = (): JSX.Element => {
  const classes: StyleClasses = useBaseStyles({} as StyleProps);
  const dispatch = useDispatch();

  const fixedHeightPaper = clsx(classes.paper, classes.fixedHeight);

  const data = useSelector(selectFuelEfficiencyData);
  const dataStatus = useSelector((state: RootState) => state.stats.status);
  const error = useSelector((state: RootState) => state.stats.error);

  useEffect(() => {
    if (dataStatus === 'idle') {
      dispatch(fetchStats());
    }
  }, [dataStatus, dispatch]);

  // TODO: Add some way to select which car is shown
  return (
    <Grid item xs={12} md={6} lg={6}>
      <Paper className={fixedHeightPaper}>
        <Title>Fuel Efficiency</Title>
        <ResponsiveContainer>
          <LineChart
            data={data['1']}
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
              dataKey="filtered"
              stroke={theme.palette.primary.main}
              dot={false}
            />
            <Line
              type="monotone"
              dataKey="raw"
              stroke="rgba(0,0,0,0)"
              dot={<EfficiencyDot data={data['1']} />}
            />
          </LineChart>
        </ResponsiveContainer>
      </Paper>
    </Grid>
  );
};
