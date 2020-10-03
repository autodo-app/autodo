import { createSlice } from '@reduxjs/toolkit';
import { AuthState } from './state';
import { logInAsync, signUpAsync } from './actions';

const initialState: AuthState = {
  token: null,
  status: 'idle',
};

const authSlice = createSlice({
  name: 'auth',
  initialState: initialState,
  reducers: {
    fetchToken(state: AuthState) {
      if (state.token) {
        state.status = 'loggedIn';
      }
      const token = localStorage.getItem('access');
      state.token = token;
      state.status = token ? 'loggedIn' : 'loggedOut';
    },
    logOut(state: AuthState) {
      localStorage.removeItem('access');
      localStorage.removeItem('refresh');
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
        state.token = payload.token;
      })
      .addCase(logInAsync.rejected, (state: AuthState, action) => {
        state.status = 'failed';
        state.error = action.error.message;
      })
      .addCase(signUpAsync.pending, (state: AuthState) => {
        state.status = 'loading';
      })
      .addCase(signUpAsync.fulfilled, (state: AuthState, { payload }) => {
        state.status = 'loggedIn';
        state.token = payload.token;
      })
      .addCase(signUpAsync.rejected, (state: AuthState, action) => {
        state.status = 'failed';
        state.error = action.error as string;
      }),
});

export default authSlice.reducer;
export const { fetchToken, logOut } = authSlice.actions;
