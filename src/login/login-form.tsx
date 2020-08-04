import * as React from 'react';
import { useState } from 'react';

interface LoginState {
  username: string;
  password: string;
}

type Props = {
  handle_login: (e: any, data: LoginState) => void;
};

export const LoginForm: React.FC<Props> = (props) => {
  const { handle_login } = props;
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');

  const onUsernameChanged = (e) => setUsername(e.target.value);
  const onPasswordChanged = (e) => setPassword(e.target.value);

  return (
    <form
      onSubmit={(e) =>
        handle_login(e, {
          username: username,
          password: password,
        })
      }
    >
      <h4>Log In</h4>
      <label htmlFor="username">Username</label>
      <input
        type="text"
        name="username"
        value={username}
        onChange={onUsernameChanged}
      />
      <label htmlFor="password">Password</label>
      <input
        type="password"
        name="password"
        value={password}
        onChange={onPasswordChanged}
      />
      <input type="submit" />
    </form>
  );
};

export default LoginForm;
