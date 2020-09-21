import { createAsyncThunk } from '@reduxjs/toolkit';

import { LOGIN, SIGNUP, LoginAction, SignupAction } from './types';
import { fetchUserToken, registerUser } from '../../_services';
import { AuthRequest } from '../../_models';

export const logInAsync = createAsyncThunk<LoginAction, AuthRequest>(
  LOGIN,
  async (request) => {
    const tokens = await fetchUserToken(request.username, request.password);
    localStorage.setItem('access', tokens.access);
    if (request.rememberMe) {
      localStorage.setItem('refresh', tokens.refresh);
    }
    return {
      type: LOGIN,
      token: tokens.access,
    };
  },
);

export const signUpAsync = createAsyncThunk<SignupAction, AuthRequest>(
  SIGNUP,
  async (request) => {
    await registerUser(request.username, request.password);
    const tokens = await fetchUserToken(request.username, request.password);
    console.log(tokens);
    localStorage.setItem('access', tokens.access);
    if (request.rememberMe) {
      localStorage.setItem('refresh', tokens.refresh);
    }
    return {
      type: SIGNUP,
      token: tokens.access,
    };
  },
);
