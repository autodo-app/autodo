import * as React from 'react';
import {
  ThemeProvider,
  CssBaseline,
  Typography,
  Link,
} from '@material-ui/core';

import theme from '../components/theme';
import Copyright from '../components/copyright';

const FourOhFour = () => {
  return (
    <React.StrictMode>
      <ThemeProvider theme={theme}>
        <CssBaseline />
        <div style={{ margin: '3rem' }}>
          <Typography variant="h4" color="textSecondary" align="center">
            404 - page not found.
          </Typography>
        </div>
        <div style={{ margin: '3rem', textAlign: 'center' }}>
          <Link variant="body1" href="/">
            Home
          </Link>
        </div>
        <Copyright />
      </ThemeProvider>
    </React.StrictMode>
  );
};

export default FourOhFour;
