import * as React from 'react';
import * as ReactDOM from 'react-dom';
import { Route, BrowserRouter } from 'react-router-dom';
import { Provider } from 'react-redux';
// @ts-ignore
import * as serviceWorker from './serviceWorker';
import { ThemeProvider, CssBaseline } from '@material-ui/core';

import { LoginPage } from './login';
import { RouteListener } from './_helpers/alert_container';
import Dashboard from './home/dashboard';
import store from './app/store';
import theme from './theme';

function App() {
  return (
    <BrowserRouter>
      <RouteListener />
      <Route exact path="/" component={Dashboard} />
      <Route exact path="/login" component={LoginPage} />
    </BrowserRouter>
  );
}

ReactDOM.render(
  <React.StrictMode>
    <Provider store={store}>
      <ThemeProvider theme={theme}>
        <CssBaseline />
        <App />
      </ThemeProvider>
    </Provider>
  </React.StrictMode>,
  document.getElementById('root'),
);

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
