import * as React from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { useEffect } from 'react';
import { Provider } from 'react-redux';
import { ThemeProvider, CssBaseline } from '@material-ui/core';
import * as Sentry from '@sentry/react';
import { Integrations } from '@sentry/tracing';

import Layout from '../components/landing/Layout';
import SEO from '../components/landing/SEO';
import ValueProp from '../components/landing/ValueProp';
import ProductBenefits from '../components/landing/ProductBenefits';
import ProductFeatures from '../components/landing/ProductFeatures';
import CallToAction from '../components/landing/CallToAction';
import Dashboard from '../components/app/home/dashboard';
import store, { RootState } from '../components/app/store';
import { fetchToken } from '../components/app/_store';
import theme from '../components/theme';

const App = () => {
  const dispatch = useDispatch();
  const authStatus = useSelector((state: RootState) => state.auth.status);
  useEffect(() => {
    if (authStatus === 'idle') {
      dispatch(fetchToken());
    }
  }, [authStatus, dispatch]);
  if (authStatus === 'loggedOut') {
    return (
      <Layout>
        <SEO title="Home" />
        <ValueProp />
        <ProductBenefits />
        <ProductFeatures />
        <CallToAction />
      </Layout>
    );
  } else if (authStatus === 'loggedIn') {
    return <Dashboard />;
  } else {
    return <></>;
  }
};

const IndexPage = () => {
  Sentry.init({
    dsn:
      'https://ab5fda67dca14d328cef7eaa6e4acfb0@o333089.ingest.sentry.io/5440666',
    integrations: [new Integrations.BrowserTracing()],
    tracesSampleRate: 0.5,
  });

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
};

export default IndexPage;
