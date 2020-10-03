import { createAsyncThunk } from '@reduxjs/toolkit';

import { LOGIN, SIGNUP, LoginAction, SignupAction } from './types';
import { fetchUserToken, registerUser } from '../../_services';
import { AuthRequest } from '../../_models';

/**
 * Used when we want to handle errors through the Promise rather than redux
 */
export const loginBasic = async (request: AuthRequest) => {
  const tokens = await fetchUserToken(request.username, request.password);
  localStorage.setItem('access', tokens.access);
  if (request.rememberMe) {
    localStorage.setItem('refresh', tokens.refresh);
  }
  return tokens;
};

export const logInAsync = createAsyncThunk<LoginAction, AuthRequest>(
  LOGIN,
  async (request) => {
    const tokens = await loginBasic(request);
    return {
      type: LOGIN,
      token: tokens.access,
    };
  },
);

/**
 * Used when we want to handle errors through the Promise rather than redux
 */
export const signupBasic = async (request: AuthRequest) => {
  await registerUser(request.username, request.password);
  const tokens = await fetchUserToken(request.username, request.password);
  console.log(tokens);
  localStorage.setItem('access', tokens.access);
  if (request.rememberMe) {
    localStorage.setItem('refresh', tokens.refresh);
  }
  return tokens;
};

export const signUpAsync = createAsyncThunk<SignupAction, AuthRequest>(
  SIGNUP,
  async (request) => {
    const tokens = await signupBasic(request);
    return {
      type: SIGNUP,
      token: tokens.access,
    };
  },
);
