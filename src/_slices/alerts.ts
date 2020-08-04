/**
 * Manages app state for alerts/toasts.
 */
import { createSlice } from '@reduxjs/toolkit';

const initialState = {};

const alertsSlice = createSlice({
  name: 'alerts',
  initialState,
  reducers: {
    alertSuccess(state, action) {
      state.type = 'alert-success';
      state.message = action.message;
    },
    alertError(state, action) {
      state.type = 'alert-error';
      state.message = action.message;
    },
    alertClear(state?: any, action?: any) {
      state = {};
    },
  },
});

export default alertsSlice.reducer;
export const { alertSuccess, alertError, alertClear } = alertsSlice.actions;
