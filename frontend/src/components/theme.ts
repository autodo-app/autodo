import { red } from '@material-ui/core/colors';
import { createMuiTheme } from '@material-ui/core/styles';

export const AUTODO_GREEN = '#4cc8a7';
export const BACKGROUND_DARK = '#222';
export const BACKGROUND_LIGHT = '#444';
export const GRAY = '#999';

// A custom theme for this app
const theme = createMuiTheme({
  typography: {
    fontFamily: ['Ubuntu', 'sans-serif'].join(','),
    fontWeightRegular: 400,
    fontSize: 16,
  },
  palette: {
    type: 'dark',
    primary: {
      main: AUTODO_GREEN,
    },
    secondary: {
      main: '#000',
    },
    error: {
      main: red.A400,
    },
    background: {
      default: BACKGROUND_DARK,
    },
    tonalOffset: 0.1,
  },
});

export default theme;
