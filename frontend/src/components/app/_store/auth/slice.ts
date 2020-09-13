import { createSlice } from '@reduxjs/toolkit';
import { AuthState } from './state';
import { logInAsync } from './actions';

const initialState: AuthState = {
  token: null,
  status: 'idle',
  error: null,
};

const authSlice = createSlice({
  name: 'auth',
  initialState: initialState,
  reducers: {
    fetchToken(state: AuthState) {
      const token = localStorage.getItem('token');
      state.token = token;
      state.status = token ? 'loggedIn' : 'loggedOut';
    },
    logOut(state: AuthState) {
      localStorage.removeItem('token');
      state.token = null;
      state.status = 'loggedOut';
    },
  },
  extraReducers: (builder) =>
    builder
      .addCase(logInAsync.pending, (state: AuthState) => {
        state.status = 'loading';
      })
      .addCase(logInAsync.fulfilled, (state: AuthState, { payload }) => {
        state.status = 'loggedIn';
        state.token = payload.payload;
      })
      .addCase(logInAsync.rejected, (state: AuthState, action) => {
        state.status = 'failed';
        state.error = action.error as string;
      }),
});

export default authSlice.reducer;
export const { fetchToken, logOut } = authSlice.actions;
