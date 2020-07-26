/**
 * Extends the default React Router history to enable redirecting users from
 * outside React components, e.g. from the user actions after a login
 */
import { createBrowserHistory } from 'history';

export const history = createBrowserHistory();