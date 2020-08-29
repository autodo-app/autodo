export type FuelUsageMonthData = Map<string, Map<string, number>>;

export type FuelUsageCarData = Map<string, number>;

export interface FuelEfficiencyDataPoint {
  raw: number[];
  averages: number[];
}

export type FuelEfficiencyData = Map<string, FuelEfficiencyDataPoint>;

export type DrivingRateData = Map<string, number[]>;
