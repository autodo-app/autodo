import { configureStore, getDefaultMiddleware } from '@reduxjs/toolkit';
import logger from 'redux-logger'
import counterReducer from '../features/counter/counterSlice';
import authReducer from '../_slices/auth';
import alertsReducer from '../_slices/alerts';

export default configureStore({
  reducer: {
    counter: counterReducer,
    auth: authReducer,
    alerts: alertsReducer,
  },
  middleware: getDefaultMiddleware().concat(logger)
});
