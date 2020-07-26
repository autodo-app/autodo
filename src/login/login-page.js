import React from 'react';
import { useDispatch } from 'react-redux';
import axios from 'axios';

import LoginForm from './login-form';
import { logInAsync } from '../_slices';

const apiUrl = 'http://localhost:8000';

axios.interceptors.request.use(
  config => {
    const { origin } = new URL(config.url);
    const allowedOrigins = [apiUrl];
    const token = localStorage.getItem('token');    
    if (allowedOrigins.includes(origin)) {
      config.headers.authorization = `Bearer ${token}`;
    }
    return config;
  },
  error => {
    return Promise.reject(error);
  }
);

export function LoginPage() {
  const dispatch = useDispatch();

  const handle_login = async (e, data) => {
    e.preventDefault();
    await dispatch(logInAsync(data));
    window.location.replace('/');
  }

  return (
    <>
      <LoginForm handle_login={(e, data) => handle_login(e, data)} />
    </>
  );

}