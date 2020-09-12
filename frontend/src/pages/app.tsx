import * as React from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { useEffect } from 'react';
import { Provider } from 'react-redux';
import { ThemeProvider, CssBaseline } from '@material-ui/core';

import { LoginPage } from '../components/app/login';
import { RouteListener } from '../components/app/_helpers/alert_container';
import Dashboard from '../components/app/home/dashboard';
import store, { RootState } from '../components/app/store';
import { fetchToken } from '../components/app/_store';
import theme from '../components/app/theme';

const App = () => {
  const dispatch = useDispatch();
  const authStatus = useSelector((state: RootState) => state.auth.status);
  useEffect(() => {
    if (authStatus === 'idle') {
      dispatch(fetchToken());
    }
  }, [authStatus, dispatch]);
  return <Dashboard />;
};

function Main() {
  return (
    <React.StrictMode>
      <Provider store={store}>
        <ThemeProvider theme={theme}>
          <CssBaseline />
          <App />
        </ThemeProvider>
      </Provider>
    </React.StrictMode>
  );
}

export default Main;
