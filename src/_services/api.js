import axios from 'axios';

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

export const fetchUserToken = async (user, pass) => {
  const { data } = await axios.post(
    `${apiUrl}/auth/token/`,
    {'username': user, 'password': pass});
  console.log(data);
  localStorage.setItem('token', data.access);
  return data.access;
}