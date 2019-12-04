import 'dart:async';
import 'package:bloc/bloc.dart';
import 'state.dart';
import 'event.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  @override
  StatsState get initialState => InitialStatsState();

  @override
  Stream<StatsState> mapEventToState(
    StatsEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
