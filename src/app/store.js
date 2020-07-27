import { configureStore, getDefaultMiddleware } from '@reduxjs/toolkit';
import logger from 'redux-logger';
import counterReducer from '../features/counter/counterSlice';
import authReducer from '../_slices/auth';
import alertsReducer from '../_slices/alerts';
import dataReducer from '../_slices/data';

export default configureStore({
  reducer: {
    counter: counterReducer,
    auth: authReducer,
    alerts: alertsReducer,
    data: dataReducer,
  },
  middleware: getDefaultMiddleware().concat(logger),
});
