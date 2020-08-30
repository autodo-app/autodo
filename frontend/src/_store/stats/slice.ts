import { createSlice } from '@reduxjs/toolkit';

import { RootState } from '../../app/store';
import * as actions from './actions';
import { StatsState } from './state';

const initialState: StatsState = {
  fuelEfficiency: {},
  drivingRate: {},
  fuelUsageByCar: {},
  fuelUsageByMonth: {},
  status: 'idle',
  error: null,
};

const statsSlice = createSlice({
  name: 'stats',
  initialState: initialState,
  reducers: {},
  extraReducers: (builder) =>
    builder
      .addCase(actions.fetchStats.pending, (state: StatsState) => {
        state.status = 'loading';
      })
      .addCase(
        actions.fetchStats.fulfilled,
        (state: StatsState, { payload }) => {
          state.status = 'succeeded';
          state.fuelEfficiency = { ...payload.payload.fuelEfficiency };
          state.drivingRate = { ...payload.payload.drivingRate };
          state.fuelUsageByCar = { ...payload.payload.fuelUsageByCar };
          state.fuelUsageByMonth = { ...payload.payload.fuelUsageByMonth };
        },
      )
      .addCase(actions.fetchStats.rejected, (state: StatsState, action) => {
        state.status = 'failed';
        state.error = action.error as string;
      }),
});

export default statsSlice.reducer;
export const selectFuelEfficiencyData = (state: RootState) =>
  state.stats.fuelEfficiency;
