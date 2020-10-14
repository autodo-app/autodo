export interface OdomSnapshot {
  id?: number;
  car?: number;
  date: string;
  mileage: number;
}

export interface Car {
  id?: number;
  name: string;
  make?: string;
  model?: string;
  year?: number;
  plate?: string;
  vin?: string;
  imageName?: string;
  color: number;
  readonly odom?: number;
  snaps?: OdomSnapshot[];
}

export interface Refueling {
  id?: number;
  odomSnapshot?: OdomSnapshot;
  amount: number;
  cost: number;
}

export interface Todo {
  id?: number;
  car: number;
  completionOdomSnapshot: OdomSnapshot | null;
  name: string;
  dueMileage: number;
  dueDate: string;
  dueState?: string;
  estimatedDueDate?: boolean;
  mileageRepeatInterval?: number;
  dateRepeatIntervalDays?: number;
  dateRepeatIntervalMonths?: number;
  dateRepeatIntervalYears?: number;
}
