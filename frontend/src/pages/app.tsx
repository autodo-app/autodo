import * as React from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { useEffect } from 'react';
import * as ReactDOM from 'react-dom';
import { Route, BrowserRouter } from 'react-router-dom';
import { Provider } from 'react-redux';
import { ThemeProvider, CssBaseline } from '@material-ui/core';

import { LoginPage } from '../components/login';
import { RouteListener } from '../components/_helpers/alert_container';
import Dashboard from '../components/home/dashboard';
import store, { RootState } from '../components/app/store';
import { fetchToken } from '../components/_store';
import theme from '../components/theme';

const App = () => {
  const dispatch = useDispatch();
  const authStatus = useSelector((state: RootState) => state.auth.status);
  useEffect(() => {
    if (authStatus === 'idle') {
      dispatch(fetchToken());
    }
  }, [authStatus, dispatch]);
  return (
    <Dashboard />
    // <BrowserRouter>
    //   <RouteListener />
    //   <Route exact path="/" component={Dashboard} />
    //   <Route exact path="/login" component={LoginPage} />
    // </BrowserRouter>
  );
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

// ReactDOM.render(<Main />, document.getElementById('root'));
