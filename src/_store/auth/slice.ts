import { createSlice } from '@reduxjs/toolkit';
import { AuthState } from './state';
import { logInAsync } from './actions';

let token = localStorage.getItem('token');
const initialState: AuthState = {
  token: token,
  status: token ? 'loggedIn' : 'loggedOut',
  error: null,
};

const authSlice = createSlice({
  name: 'auth',
  initialState: initialState,
  reducers: {},
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
