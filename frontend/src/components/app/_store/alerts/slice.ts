/**
 * Manages app state for alerts/toasts.
 */
import { createSlice } from '@reduxjs/toolkit';
import { AlertsState } from './state';

const initialState: AlertsState = {};

const alertsSlice = createSlice({
  name: 'alerts',
  initialState,
  reducers: {
    alertSuccess(state: AlertsState, action) {
      state.type = 'alert-success';
      state.message = action.payload;
    },
    alertError(state: AlertsState, action) {
      state.type = 'alert-error';
      state.message = action.payload;
    },
    alertClear(state?: AlertsState) {
      state = {};
    },
  },
});

export default alertsSlice.reducer;
export const { alertSuccess, alertError, alertClear } = alertsSlice.actions;
