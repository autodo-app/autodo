import { configureStore, getDefaultMiddleware } from '@reduxjs/toolkit';
import logger from 'redux-logger';
import authReducer from '../_store/auth/slice';
import alertsReducer from '../_store/alerts/slice';
import dataReducer from '../_store/data/slice';
import statsReducer from '../_store/stats/slice';
import { AuthState, AlertsState, DataState, StatsState } from '../_store';

const store = configureStore({
  reducer: {
    auth: authReducer,
    alerts: alertsReducer,
    data: dataReducer,
    stats: statsReducer,
  },
  middleware: getDefaultMiddleware().concat(logger),
});

export default store;

export type RootState = {
  auth: AuthState;
  alerts: AlertsState;
  data: DataState;
  stats: StatsState;
};
