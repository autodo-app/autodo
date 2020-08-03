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
  car: number;
  completionOdomSnapshot: OdomSnapshot;
  name: string;
  dueMileage: number;
  dueDate: Date;
  estimatedDueDate: boolean;
  mileageRepeatInterval: number;
  daysRepeatInterval: number;
  monthsRepeatInterval: number;
  yearsRepeatInterval: number;
}
