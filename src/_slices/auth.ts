/**
 * Manages app state for login and logout actions.
 */
import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';

import { fetchUserToken } from '../_services';

let token = localStorage.getItem('token');
const initialState = {
  token: token,
  status: token ? 'loggedIn' : 'loggedOut',
  error: null,
};

export const logInAsync = createAsyncThunk(
  'auth/logInAsync',
  async (request: any) => {
    const token = await fetchUserToken(request.username, request.password);
    return token;
  },
);

export const authSlice = createSlice({
  name: 'auth',
  initialState: initialState,
  reducers: {
    logIn(state, action) {
      state.token = action.payload;
    },
  },
  extraReducers: {
    [logInAsync.pending]: (state, action) => {
      state.status = 'loading';
    },
    [logInAsync.fulfilled]: (state, action) => {
      state.status = 'loggedIn';
      state.token = action.payload;
    },
    [logInAsync.rejected]: (state, action) => {
      state.status = 'failed';
      state.error = action.payload;
    },
  },
});

export default authSlice.reducer;
export const { logIn } = authSlice.actions;
