import * as api from '../../_services';
import * as types from './types';
import { createAsyncThunk } from '@reduxjs/toolkit';

export const fetchStats = createAsyncThunk<types.FetchStatsAction, void>(
  types.FETCH_STATS,
  async () => {
    const [
      fuelEfficiency,
      fuelUsageByCar,
      drivingRate,
      fuelUsageByMonth,
    ] = await Promise.all([
      api.fetchFuelEfficiency(),
      api.fetchFuelUsageByCar(),
      api.fetchDrivingRate(),
      api.fetchFuelUsageByMonth(),
    ]);
    return {
      type: types.FETCH_STATS,
      payload: {
        fuelEfficiency: fuelEfficiency,
        fuelUsageByCar: fuelUsageByCar,
        drivingRate: drivingRate,
        fuelUsageByMonth: fuelUsageByMonth,
      },
    } as types.FetchStatsAction;
  },
);
