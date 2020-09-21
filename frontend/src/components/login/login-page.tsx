import * as React from 'react';
import { useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';

import LoginForm from './login-form';
import { RootState } from '../app/store';
import { AuthRequest } from '../app/_models';
import { logInAsync } from '../app/_store';

export function LoginPage() {
  const dispatch = useDispatch();
  const authStatus = useSelector((state: RootState) => state.auth.status);
  useEffect(() => {
    if (authStatus === 'loggedIn') {
      window.location.replace('/');
    }
  }, [authStatus]);

  const handle_login = async (
    e: React.ChangeEvent<HTMLInputElement>,
    data: AuthRequest,
  ) => {
    e.preventDefault();
    await dispatch(logInAsync(data));
  };

  return (
    <>
      <LoginForm
        handle_login={(e, data) => handle_login(e, data)}
        initState="login"
      />
    </>
  );
}
