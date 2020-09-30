import * as React from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { useEffect } from 'react';
import { Provider } from 'react-redux';
import { ThemeProvider, CssBaseline } from '@material-ui/core';

import { LoginPage } from '../components/login';
import store, { RootState } from '../components/app/store';
import { fetchToken } from '../components/app/_store';
import theme from '../components/theme';

const Login = () => {
  const dispatch = useDispatch();
  const authStatus = useSelector((state: RootState) => state.auth.status);
  useEffect(() => {
    if (authStatus === 'idle') {
      dispatch(fetchToken());
    }
  }, [authStatus, dispatch]);
  return <LoginPage />;
};

function Main() {
  return (
    <React.StrictMode>
      <Provider store={store}>
        <ThemeProvider theme={theme}>
          <CssBaseline />
          <Login />
        </ThemeProvider>
      </Provider>
    </React.StrictMode>
  );
}

export default Main;
