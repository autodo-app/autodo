import { DataState } from './state';
import { Todo } from '../../_slices';

export const FETCH_DATA = 'FETCH_DATA';
export const CREATE_TODO = 'CREATE_TODO';
export const UPDATE_TODO = 'UPDATE_TODO';
export const DELETE_TODO = 'DELETE_TODO';
export const COMPLETE_TODO = 'COMPLETE_TODO';

interface FetchDataAction {
  type: typeof FETCH_DATA;
  payload: DataState;
}

interface CreateTodoAction {
  type: typeof CREATE_TODO;
  payload: Todo;
}

interface UpdateTodoAction {
  type: typeof UPDATE_TODO;
  payload: Todo;
}

interface DeleteTodoAction {
  type: typeof DELETE_TODO;
  payload: Todo;
}

interface CompleteTodoAction {
  type: typeof COMPLETE_TODO;
  payload: Todo;
}

export type DataActionTypes =
  | FetchDataAction
  | CreateTodoAction
  | UpdateTodoAction
  | DeleteTodoAction
  | CompleteTodoAction;
