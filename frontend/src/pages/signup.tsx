import * as React from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { useEffect } from 'react';
import { Provider } from 'react-redux';
import { ThemeProvider, CssBaseline } from '@material-ui/core';

import store, { RootState } from '../components/app/store';
import { fetchToken } from '../components/app/_store';
import theme from '../components/theme';

import LoginForm from '../components/login/login-form';
import { AuthRequest } from '../components/app/_models';
import { signUpAsync } from '../components/app/_store';

const SignUpPage = () => {
  const dispatch = useDispatch();
  const authStatus = useSelector((state: RootState) => state.auth.status);
  useEffect(() => {
    if (authStatus === 'loggedIn') {
      window.location.replace('/');
    }
  }, [authStatus]);

  const handle_signup = async (
    e: React.ChangeEvent<HTMLInputElement>,
    data: AuthRequest,
  ) => {
    e.preventDefault();
    await dispatch(signUpAsync(data));
  };

  return (
    <>
      <LoginForm
        handle_login={(e, data) => handle_signup(e, data)}
        initState="signup"
      />
    </>
  );
};

const SignUp = () => {
  const dispatch = useDispatch();
  const authStatus = useSelector((state: RootState) => state.auth.status);
  useEffect(() => {
    if (authStatus === 'idle') {
      dispatch(fetchToken());
    }
  }, [authStatus, dispatch]);
  return <SignUpPage />;
};

function Main() {
  return (
    <React.StrictMode>
      <Provider store={store}>
        <ThemeProvider theme={theme}>
          <CssBaseline />
          <SignUp />
        </ThemeProvider>
      </Provider>
    </React.StrictMode>
  );
}

export default Main;
