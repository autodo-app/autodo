export interface AuthState {
  token: string;
  status: 'loggedIn' | 'loggedOut';
  error: string | null;
}
