import axios from 'axios';

const apiUrl = 'http://localhost:8000';
const apiVersion = '/api/v1';

axios.interceptors.request.use(
  (config) => {
    const { origin } = new URL(config.url);
    const allowedOrigins = [apiUrl];
    const token = localStorage.getItem('token');
    if (allowedOrigins.includes(origin)) {
      config.headers.authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  },
);

const _refreshUserToken = async () => {
  // TODO: use the refresh token to get a new access token
};

const _authenticatedGet = async (url) => {
  const { data, status } = await axios.get(`${apiUrl}${apiVersion}/${url}`);
  if (status === 401) {
    // Token has expired, need to refresh it
    await _refreshUserToken();
  }

  if (status !== 200) {
    // throw an error
  }
  return data;
};

export const fetchUserToken = async (user, pass) => {
  const { data } = await axios.post(`${apiUrl}/auth/token/`, { username: user, password: pass });
  localStorage.setItem('token', data.access);
  return data.access;
};

export const fetchTodos = async () => {
  const response = await _authenticatedGet('todos/');
  return response;
};

export const fetchRefuelings = async () => {
  const response = await _authenticatedGet('refuelings/');
  return response;
};

export const fetchCars = async () => {
  const response = await _authenticatedGet('cars/');
  return response;
};
