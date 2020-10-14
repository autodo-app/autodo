enum TodoDueState { PAST_DUE, DUE_SOON, UPCOMING, COMPLETE }

/// If a ToDo is due in fewer days than this, then it is considered DUE_SOON.
const DUE_SOON_CUTOFF_TIME = 14;

/// Used to determine if a ToDo is DUE_SOON when there is not enough data for
/// the car to have a distanceRate value.
/// Average person drives ~13,500mi a year, so roughly 40mi per day, which is
/// roughly 60 kilometers per day
/// ^source: https://www.carinsurance.com/Articles/average-miles-driven-per-year-by-state.aspx
const DEFAULT_DUE_SOON_CUTOFF_DISTANCE_RATE = 60.0;
