export type FuelUsageMonthData = Map<string, Map<string, number>>;

export type FuelUsageCarData = Map<string, number>;

export interface FuelEfficiencyDataPoint {
  time: Date;
  raw: number;
  filtered: number;
}

export type FuelEfficiencyData = Map<string, FuelEfficiencyDataPoint[]>;

export type DrivingRateData = Map<string, number[]>;
