import { Car, Refueling, Todo } from '../../_slices';

export interface DataState {
  todos: Todo[];
  refuelings: Refueling[];
  cars: Car[];
  defaultTodos: Todo[];
  status: string;
  error: string;
}
