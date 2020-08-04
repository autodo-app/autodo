export interface Car {
  name: string;
  make: string;
  model: string;
  year: string;
  plate: string;
  vin: string;
  imageName: string;
  color: number;
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
  completionOdomSnapshot: OdomSnapshot;
  name: string;
  dueMileage: number;
  dueDate: string;
  estimatedDueDate?: boolean;
  mileageRepeatInterval?: number;
  dateRepeatIntervalDays?: number;
  dateRepeatIntervalMonths?: number;
  dateRepeatIntervalYears?: number;
}
