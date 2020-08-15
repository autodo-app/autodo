import { configureStore, getDefaultMiddleware } from '@reduxjs/toolkit';
import logger from 'redux-logger';
import authReducer from '../_store/auth/slice';
import alertsReducer from '../_store/alerts/slice';
import dataReducer from '../_store/data/slice';
import { AuthState } from '../_store/auth/state';
import { AlertsState } from '../_store/alerts/state';
import { DataState } from '../_store/data/state';

const store = configureStore({
  reducer: {
    auth: authReducer,
    alerts: alertsReducer,
    data: dataReducer,
  },
  middleware: getDefaultMiddleware().concat(logger),
});

export default store;

export type RootState = {
  auth: AuthState;
  alerts: AlertsState;
  data: DataState;
};
