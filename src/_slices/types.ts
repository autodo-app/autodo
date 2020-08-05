export interface Car {
  id: number;
  name: string;
  make: string;
  model: string;
  year: string;
  plate: string;
  vin: string;
  imageName: string;
  color: number;
  odom: number;
}

export interface OdomSnapshot {
  car: number;
  date: Date;
  mileage: number;
}

export interface Refueling {
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
  estimatedDueDate?: boolean;
  mileageRepeatInterval?: number;
  dateRepeatIntervalDays?: number;
  dateRepeatIntervalMonths?: number;
  dateRepeatIntervalYears?: number;
}
