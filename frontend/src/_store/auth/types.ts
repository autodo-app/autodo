export const LOGIN = 'LOGIN';
export const LOGOUT = 'LOGOUT';
export const SIGNUP = 'SIGNUP';
export const RESET_PASSWORD = 'RESET_PASSWORD';

export interface LoginAction {
  type: typeof LOGIN;
  payload: string;
}

export interface LogoutAction {
  type: typeof LOGOUT;
}

export interface SignupAction {
  type: typeof SIGNUP;
  payload: string;
}

export interface ResetPasswordAction {
  type: typeof RESET_PASSWORD;
}
