export interface AuthState {
  token: string | null;
  status: 'loading' | 'loggedIn' | 'loggedOut' | 'failed';
  error: string | null;
}
