enum TodoDueState { PAST_DUE, DUE_SOON, UPCOMING, COMPLETE }

/// If a ToDo is due in fewer days than this, then it is considered DUE_SOON.
const DUE_SOON_CUTOFF_TIME = 14;

/// Used to determine if a ToDo is DUE_SOON when there is not enough data for
/// the car to have a distanceRate value.
const DEFAULT_DUE_SOON_CUTOFF_DISTANCE_RATE = 10;