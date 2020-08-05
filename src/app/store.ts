import { configureStore, getDefaultMiddleware } from '@reduxjs/toolkit';
import logger from 'redux-logger';
import authReducer from '../_slices/auth';
import alertsReducer from '../_slices/alerts';
import dataReducer from '../_slices/data';
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
