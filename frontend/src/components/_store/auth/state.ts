export interface AuthState {
  token: string | null;
  status: 'idle' | 'loading' | 'loggedIn' | 'loggedOut' | 'failed';
  error: string | null;
}
