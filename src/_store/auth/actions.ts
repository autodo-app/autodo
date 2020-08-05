import { createAsyncThunk } from '@reduxjs/toolkit';

import { LOGIN, LoginAction } from './types';
import { fetchUserToken } from '../../_services';
import { AuthRequest } from '../../_models';

export const logInAsync = createAsyncThunk<LoginAction, AuthRequest>(
  LOGIN,
  async (request) => {
    const token = await fetchUserToken(request.username, request.password);
    return token;
  },
);
