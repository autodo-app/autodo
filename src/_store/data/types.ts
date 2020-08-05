import { DataState } from './state';
import { Todo } from '../../_models';

export const FETCH_DATA = 'FETCH_DATA';
export const CREATE_TODO = 'CREATE_TODO';
export const UPDATE_TODO = 'UPDATE_TODO';
export const DELETE_TODO = 'DELETE_TODO';
export const COMPLETE_TODO = 'COMPLETE_TODO';
export const UNCOMPLETE_TODO = 'UNCOMPLETE_TODO';

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

export type DataActionTypes =
  | FetchDataAction
  | CreateTodoAction
  | UpdateTodoAction
  | DeleteTodoAction
  | CompleteTodoAction
  | UnCompleteTodoAction;
