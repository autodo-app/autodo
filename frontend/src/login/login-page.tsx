import * as React from 'react';
import { useDispatch } from 'react-redux';

import LoginForm from './login-form';
import { AuthRequest } from '../_models';
import { logInAsync } from '../_store';

export function LoginPage() {
  const dispatch = useDispatch();

  const handle_login = async (
    e: React.ChangeEvent<HTMLInputElement>,
    data: AuthRequest,
  ) => {
    e.preventDefault();
    await dispatch(logInAsync(data));
    window.location.replace('/');
  };

  return (
    <>
      <LoginForm handle_login={(e, data) => handle_login(e, data)} />
    </>
  );
}
