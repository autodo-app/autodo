import * as models from '../../_models';
import {
  FuelEfficiencyData,
  FuelUsageCarData,
  FuelUsageMonthData,
  DrivingRateData,
} from '../../_models';

export interface StatsState {
  fuelEfficiency: FuelEfficiencyData;
  fuelUsageByCar: FuelUsageCarData;
  drivingRate: DrivingRateData;
  fuelUsageByMonth: FuelUsageMonthData;
  status: string;
  error: string | null;
}
