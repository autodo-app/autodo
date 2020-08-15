import axios from 'axios';

import { Car, OdomSnapshot, Refueling, Todo } from '../_models/data';

const apiUrl = 'http://localhost:8000';
const apiVersion = '/api/v1';

axios.interceptors.request.use(
  (config) => {
    const { origin } = new URL(config.url ?? '');
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

const _authenticatedGet = async (url: string) => {
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

const _authenticatedPost = async (url: string, body: any): Promise<any> => {
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

const _authenticatedPatch = async (url: string, body: any): Promise<any> => {
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

const _authenticatedDelete = async (url: string, body: any): Promise<any> => {
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

export const fetchUserToken = async (user: string, pass: string) => {
  const { data } = await axios.post(`${apiUrl}/auth/token/`, {
    username: user,
    password: pass,
  });
  localStorage.setItem('token', data.access);
  return data.access;
};

export const fetchTodos = async (): Promise<Todo[]> => {
  const response = await _authenticatedGet('todos/');
  return response.results;
};

export const postTodo = async (todo: Todo): Promise<Todo> => {
  const response = await _authenticatedPost('todos/', todo);
  return response;
};

export const patchTodo = async (todo: Todo): Promise<Todo> => {
  const response = await _authenticatedPatch(`todos/${todo.id}/`, todo);
  return response;
};

export const deleteTodo = async (todo: Todo): Promise<Todo> => {
  await _authenticatedDelete(`todos/${todo.id}/`, todo);
  return todo;
};

export const fetchRefuelings = async (): Promise<Refueling[]> => {
  const response = await _authenticatedGet('refuelings/');
  return response.results;
};

export const postRefueling = async (
  refueling: Refueling,
): Promise<Refueling> => {
  const response = await _authenticatedPost('refuelings/', refueling);
  return response;
};

export const patchRefueling = async (
  refueling: Refueling,
): Promise<Refueling> => {
  const response = await _authenticatedPatch(
    `refuelings/${refueling.id}/`,
    refueling,
  );
  return response;
};

export const deleteRefueling = async (
  refueling: Refueling,
): Promise<Refueling> => {
  await _authenticatedDelete(`refuelings/${refueling.id}/`, refueling);
  return refueling;
};

export const fetchCars = async (): Promise<Car[]> => {
  const response = await _authenticatedGet('cars/');
  return response.results;
};

export const postCar = async (car: Car): Promise<Car> => {
  const response = await _authenticatedPost('cars/', car);
  return response;
};

export const patchCar = async (car: Car): Promise<Car> => {
  const response = await _authenticatedPatch(`cars/${car.id}/`, car);
  return response;
};

export const deleteCar = async (car: Car): Promise<Car> => {
  await _authenticatedDelete(`cars/${car.id}/`, car);
  return car;
};

export const postOdomSnapshot = async (
  snap: OdomSnapshot,
): Promise<OdomSnapshot> => await _authenticatedPost('odomsnapshots/', snap);

export const patchOdomSnapshot = async (
  snap: OdomSnapshot,
): Promise<OdomSnapshot> =>
  await _authenticatedPatch(`odomsnapshots/${snap.id}`, snap);

export const deleteOdomSnapshot = async (
  snapId: number,
): Promise<OdomSnapshot> =>
  await _authenticatedDelete(`odomsnapshots/${snapId}/`, snapId);
