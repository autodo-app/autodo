import * as React from 'react';
import { useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';

import LoginForm from './login-form';
import { RootState } from '../app/store';

export function LoginPage() {
  const authStatus = useSelector((state: RootState) => state.auth.status);
  useEffect(() => {
    if (authStatus === 'loggedIn') {
      window.location.replace('/');
    }
  }, [authStatus]);

  return (
    <>
      <LoginForm initState="login" />
    </>
  );
}
