import { StatsState } from './state';

export const FETCH_STATS = 'FETCH_STATS';

export interface FetchStatsAction {
  type: typeof FETCH_STATS;
  payload: StatsState;
}
