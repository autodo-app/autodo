export interface Car {
  id?: number;
  name: string;
  make?: string;
  model?: string;
  year?: string;
  plate?: string;
  vin?: string;
  imageName?: string;
  color: number | null;
  readonly odom?: number;
}

export interface OdomSnapshot {
  id?: number;
  car?: number;
  date: Date;
  mileage: number;
}

export interface Refueling {
  id?: number;
  odomSnapshot: OdomSnapshot;
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
