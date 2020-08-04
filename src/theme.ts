import { red } from '@material-ui/core/colors';
import { createMuiTheme } from '@material-ui/core/styles';

export const AUTODO_GREEN = '#4cc8a7';
export const BACKGROUND_DARK = '#222';
export const BACKGROUND_LIGHT = '#444';

// A custom theme for this app
const theme = createMuiTheme({
  palette: {
    type: 'dark',
    primary: {
      main: AUTODO_GREEN,
    },
    secondary: {
      main: '#19857b',
    },
    error: {
      main: red.A400,
    },
    background: {
      default: BACKGROUND_DARK,
    },
  },
});

export default theme;
