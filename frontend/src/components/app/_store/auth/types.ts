export const LOGIN = 'LOGIN';
export const LOGOUT = 'LOGOUT';
export const SIGNUP = 'SIGNUP';
export const RESET_PASSWORD = 'RESET_PASSWORD';
export const FETCH_TOKEN = 'FETCH_TOKEN';

export interface LoginAction {
  type: typeof LOGIN;
  token: string;
}

export interface FetchTokenAction {
  type: typeof LOGIN;
}

export interface LogoutAction {
  type: typeof LOGOUT;
}

export interface SignupAction {
  type: typeof SIGNUP;
  token: string;
}

export interface ResetPasswordAction {
  type: typeof RESET_PASSWORD;
}
