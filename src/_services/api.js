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

const _authenticatedPost = async (url, body) => {
  try {
    const { data, status } = await axios.post(
      `${apiUrl}${apiVersion}/${url}`,
      body,
    );
    if (status === 401) {
      // Token has expired, need to refresh it
      await _refreshUserToken();
    }

    if (status !== 201) {
      // throw an error
    }
    return data;
  } catch (e) {
    console.log(e.response);
  }
};

const _authenticatedPatch = async (url, body) => {
  try {
    const { data, status } = await axios.patch(
      `${apiUrl}${apiVersion}/${url}`,
      body,
    );
    if (status === 401) {
      // Token has expired, need to refresh it
      await _refreshUserToken();
    }

    if (status !== 201) {
      // throw an error
    }
    return data;
  } catch (e) {
    console.log(e.response);
  }
};

const _authenticatedDelete = async (url, body) => {
  const { data, status } = await axios.delete(
    `${apiUrl}${apiVersion}/${url}`,
    body,
  );
  if (status === 401) {
    // Token has expired, need to refresh it
    await _refreshUserToken();
  }

  if (status !== 201) {
    // throw an error
  }
  return data;
};

export const fetchUserToken = async (user, pass) => {
  const { data } = await axios.post(`${apiUrl}/auth/token/`, {
    username: user,
    password: pass,
  });
  localStorage.setItem('token', data.access);
  return data.access;
};

export const fetchTodos = async () => {
  const response = await _authenticatedGet('todos/');
  return response.results;
};

export const apiPostTodo = async (todo) => {
  const response = await _authenticatedPost('todos/', todo);
  return response;
};

export const apiPatchTodo = async (todo) => {
  const response = await _authenticatedPatch(`todos/${todo.id}/`, todo);
  return response;
};

export const apiDeleteTodo = async (todo) => {
  await _authenticatedDelete(`todos/${todo.id}/`, todo);
  return todo;
};

export const fetchRefuelings = async () => {
  const response = await _authenticatedGet('refuelings/');
  return response.results;
};

export const fetchCars = async () => {
  const response = await _authenticatedGet('cars/');
  return response.results;
};

export const apiPostOdomSnapshot = async (snap) =>
  await _authenticatedPost('odomsnapshots/', snap);

export const apiDeleteOdomSnapshot = async (snapId) =>
  await _authenticatedDelete(`odomsnapshots/${snapId}/`, snapId);
