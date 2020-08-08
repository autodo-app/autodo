import { DataState } from './state';
import { Todo, Refueling, Car } from '../../_models';

export const FETCH_DATA = 'FETCH_DATA';
export const CREATE_TODO = 'CREATE_TODO';
export const UPDATE_TODO = 'UPDATE_TODO';
export const DELETE_TODO = 'DELETE_TODO';
export const COMPLETE_TODO = 'COMPLETE_TODO';
export const UNCOMPLETE_TODO = 'UNCOMPLETE_TODO';
export const CREATE_REFUELING = 'CREATE_REFUELING';
export const UPDATE_REFUELING = 'UPDATE_REFUELING';
export const DELETE_REFUELING = 'DELETE_REFUELING';
export const CREATE_CAR = 'CREATE_CAR';
export const UPDATE_CAR = 'UPDATE_CAR';
export const DELETE_CAR = 'DELETE_CAR';

export interface FetchDataAction {
  type: typeof FETCH_DATA;
  payload: DataState;
}

export interface CreateTodoAction {
  type: typeof CREATE_TODO;
  payload: Todo;
}

export interface UpdateTodoAction {
  type: typeof UPDATE_TODO;
  payload: Todo;
}

export interface DeleteTodoAction {
  type: typeof DELETE_TODO;
  payload: Todo;
}

export interface CompleteTodoAction {
  type: typeof COMPLETE_TODO;
  payload: Todo;
}

export interface UnCompleteTodoAction {
  type: typeof UNCOMPLETE_TODO;
  payload: Todo[];
}

export interface CreateRefuelingAction {
  type: typeof CREATE_REFUELING;
  payload: Refueling;
}

export interface UpdateRefuelingAction {
  type: typeof UPDATE_REFUELING;
  payload: Refueling;
}

export interface DeleteRefuelingAction {
  type: typeof DELETE_REFUELING;
  payload: Refueling;
}

export interface CreateCarAction {
  type: typeof CREATE_CAR;
  payload: Car;
}

export interface UpdateCarAction {
  type: typeof UPDATE_CAR;
  payload: Car;
}

export interface DeleteCarAction {
  type: typeof DELETE_CAR;
  payload: Car;
}

export type DataActionTypes =
  | FetchDataAction
  | CreateTodoAction
  | UpdateTodoAction
  | DeleteTodoAction
  | CompleteTodoAction
  | UnCompleteTodoAction
  | CreateRefuelingAction
  | UpdateRefuelingAction
  | DeleteRefuelingAction
  | CreateCarAction
  | UpdateCarAction
  | DeleteCarAction;
