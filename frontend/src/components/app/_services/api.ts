import axios from 'axios';

import * as models from '../_models';

const apiUrl = 'http://localhost:8000';
const apiVersion = '/api/v1';
const REGISTER_ADDRESS = `${apiUrl}/accounts/register/`;

axios.interceptors.request.use(
  (config) => {
    const { origin } = new URL(config.url ?? '');
    const allowedOrigins = [apiUrl];
    const token = localStorage.getItem('access');
    if (allowedOrigins.includes(origin) && config.url !== REGISTER_ADDRESS) {
      // don't send the access token when we're trying to sign up a new user
      config.headers.authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  },
);

const _refreshUserToken = async () => {
  const { data, status } = await axios.post(`${apiUrl}/auth/token/refresh/`, {
    refresh: localStorage.getItem('refresh'),
  });
  if (status !== 200) {
    console.log('Failed to refresh access token');
  }
  const newAccessToken = data['access'];
  localStorage.setItem('access', newAccessToken);
  console.log('here');
};

const _authenticatedGet = async (url: string) => {
  let response;
  try {
    response = await axios.get(`${apiUrl}${apiVersion}/${url}`);
    if (response.status === 401) {
      // Token has expired, need to refresh it
      console.log('401');
      await _refreshUserToken();
      response = await axios.get(`${apiUrl}${apiVersion}/${url}`);
    }

    if (response.status !== 200) {
      console.log(`Not 200: ${response.status}`);
    }

    return response.data;
  } catch (error) {
    console.log(error);
    await _refreshUserToken();
    response = await axios.get(`${apiUrl}${apiVersion}/${url}`);
    return response.data;
  }
};

const _authenticatedPost = async (url: string, body: any): Promise<any> => {
  let response;
  try {
    response = await axios.post(`${apiUrl}${apiVersion}/${url}`, body);
    if (response.status === 401) {
      // Token has expired, need to refresh it
      await _refreshUserToken();
      response = await axios.post(`${apiUrl}${apiVersion}/${url}`, body);
    }

    if (response.status !== 201) {
      // error
    }
    return response.data;
  } catch (e) {
    console.log(e.response);
    await _refreshUserToken();
    response = await axios.post(`${apiUrl}${apiVersion}/${url}`, body);
    return response.data;
  }
};

const _authenticatedPatch = async (url: string, body: any): Promise<any> => {
  let response;
  try {
    response = await axios.patch(`${apiUrl}${apiVersion}/${url}`, body);
    if (response.status === 401) {
      // Token has expired, need to refresh it
      await _refreshUserToken();
      response = await axios.patch(`${apiUrl}${apiVersion}/${url}`, body);
    }

    if (response.status !== 201) {
      // throw an error
    }
    return response.data;
  } catch (e) {
    console.log(e.response);
    response = await axios.post(`${apiUrl}${apiVersion}/${url}`, body);
    return response.data;
  }
};

const _authenticatedDelete = async (url: string, body: any): Promise<any> => {
  let response;
  try {
    response = await axios.delete(`${apiUrl}${apiVersion}/${url}`, body);
    if (response.status === 401) {
      // Token has expired, need to refresh it
      await _refreshUserToken();
      response = await axios.delete(`${apiUrl}${apiVersion}/${url}`, body);
    }

    if (response.status !== 201) {
      // throw an error
    }
    return response.data;
  } catch (e) {
    await _refreshUserToken();
    response = await axios.delete(`${apiUrl}${apiVersion}/${url}`, body);
    return response.data;
  }
};

export const fetchUserToken = async (user: string, pass: string) => {
  const { data } = await axios.post(`${apiUrl}/auth/token/`, {
    username: user,
    password: pass,
  });
  return data;
};

export const registerUser = async (user: string, pass: string) => {
  const { data } = await axios.post(REGISTER_ADDRESS, {
    username: user,
    email: user,
    password: pass,
    password_confirm: pass,
  });
  return data;
};

export const fetchTodos = async (): Promise<models.Todo[]> => {
  const response = await _authenticatedGet('todos/');
  return response.results;
};

export const postTodo = async (todo: models.Todo): Promise<models.Todo> => {
  const response = await _authenticatedPost('todos/', todo);
  return response;
};

export const patchTodo = async (todo: models.Todo): Promise<models.Todo> => {
  const response = await _authenticatedPatch(`todos/${todo.id}/`, todo);
  return response;
};

export const deleteTodo = async (todo: models.Todo): Promise<models.Todo> => {
  await _authenticatedDelete(`todos/${todo.id}/`, todo);
  return todo;
};

export const fetchRefuelings = async (): Promise<models.Refueling[]> => {
  const response = await _authenticatedGet('refuelings/');
  return response.results;
};

export const postRefueling = async (
  refueling: models.Refueling,
): Promise<models.Refueling> => {
  const response = await _authenticatedPost('refuelings/', refueling);
  return response;
};

export const patchRefueling = async (
  refueling: models.Refueling,
): Promise<models.Refueling> => {
  const response = await _authenticatedPatch(
    `refuelings/${refueling.id}/`,
    refueling,
  );
  return response;
};

export const deleteRefueling = async (
  refueling: models.Refueling,
): Promise<models.Refueling> => {
  await _authenticatedDelete(`refuelings/${refueling.id}/`, refueling);
  return refueling;
};

export const fetchCars = async (): Promise<models.Car[]> => {
  const response = await _authenticatedGet('cars/');
  return response.results;
};

export const postCar = async (car: models.Car): Promise<models.Car> => {
  const response = await _authenticatedPost('cars/', car);
  return response;
};

export const patchCar = async (car: models.Car): Promise<models.Car> => {
  const response = await _authenticatedPatch(`cars/${car.id}/`, car);
  return response;
};

export const deleteCar = async (car: models.Car): Promise<models.Car> => {
  await _authenticatedDelete(`cars/${car.id}/`, car);
  return car;
};

export const postOdomSnapshot = async (
  snap: models.OdomSnapshot,
): Promise<models.OdomSnapshot> =>
  await _authenticatedPost('odomsnapshots/', snap);

export const patchOdomSnapshot = async (
  snap: models.OdomSnapshot,
): Promise<models.OdomSnapshot> =>
  await _authenticatedPatch(`odomsnapshots/${snap.id}`, snap);

export const deleteOdomSnapshot = async (
  snapId: number,
): Promise<models.OdomSnapshot> =>
  await _authenticatedDelete(`odomsnapshots/${snapId}/`, snapId);

export const fetchFuelEfficiency = async (): Promise<
  models.FuelEfficiencyData
> => await _authenticatedGet('fuelefficiencystats/');

export const fetchFuelUsageByCar = async (): Promise<models.FuelUsageCarData> =>
  await _authenticatedGet('fuelusagebycar/');

export const fetchDrivingRate = async (): Promise<models.DrivingRateData> =>
  await _authenticatedGet('drivingrate/');

export const fetchFuelUsageByMonth = async (): Promise<
  models.FuelUsageMonthData
> => await _authenticatedGet('fuelusagebymonth/');
