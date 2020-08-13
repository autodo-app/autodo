import { Car, Refueling, Todo } from '../../_models';

export interface DataState {
  todos: Todo[];
  refuelings: Refueling[];
  cars: Car[];
  defaultTodos: Todo[];
  status: string;
  error: string | null;
}
