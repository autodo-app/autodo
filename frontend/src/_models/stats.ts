interface FuelUsageMonth {
  [monthId: string]: number;
}

export interface FuelUsageMonthData {
  [carId: string]: FuelUsageMonth;
}

export interface FuelUsageCarData {
  [carId: string]: number;
}

export interface FuelEfficiencyDataPoint {
  time: Date;
  raw: number;
  filtered: number;
}

export interface FuelEfficiencyData {
  [carId: string]: FuelEfficiencyDataPoint[];
}

interface DrivingRatePoint {
  time: Date;
  rate: number;
}
export interface DrivingRateData {
  [carId: string]: DrivingRatePoint[];
}
