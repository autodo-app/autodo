import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:bloc/bloc.dart';
import 'event.dart';
import 'state.dart';
import 'package:autodo/repositories/barrel.dart';
import 'package:autodo/models/barrel.dart';

class RepeatsBloc extends Bloc<RepeatsEvent, RepeatsState> {
  final DataRepository _dataRepository;
  StreamSubscription _repeatsSubscription;

  RepeatsBloc({@required DataRepository dataRepository})
      : assert(dataRepository != null),
        _dataRepository = dataRepository;

  @override
  RepeatsState get initialState => RepeatsLoading();

  @override
  Stream<RepeatsState> mapEventToState(RepeatsEvent event) async* {
    if (event is LoadRepeats) {
      yield* _mapLoadRepeatsToState();
    } else if (event is AddRepeat) {
      yield* _mapAddRepeatToState(event);
    } else if (event is UpdateRepeat) {
      yield* _mapUpdateRepeatToState(event);
    } else if (event is DeleteRepeat) {
      yield* _mapDeleteRepeatToState(event);
    } else if (event is RepeatsUpdated) {
      yield* _mapRepeatsUpdateToState(event);
    }
  }

  Stream<RepeatsState> _mapLoadRepeatsToState() async* {
    _repeatsSubscription?.cancel();
    _repeatsSubscription = _dataRepository.repeats().listen(
          (repeats) => add(RepeatsUpdated(repeats)),
        );
  }

  Stream<RepeatsState> _mapAddRepeatToState(AddRepeat event) async* {
    Repeat out;
    _dataRepository.addNewRepeat(out);
  }

  Stream<RepeatsState> _mapUpdateRepeatToState(UpdateRepeat event) async* {
    _dataRepository.updateRepeat(event.updatedRepeat);
  }

  Stream<RepeatsState> _mapDeleteRepeatToState(DeleteRepeat event) async* {
    _dataRepository.deleteRepeat(event.repeat);
  }

  Stream<RepeatsState> _mapRepeatsUpdateToState(RepeatsUpdated event) async* {
    yield RepeatsLoaded(event.repeats);
  }

  List sortItems(List items) {
    return items
      ..sort((a, b) {
        var aDate = a.data['dueDate'] ?? 0;
        var bDate = b.data['dueDate'] ?? 0;
        var aMileage = a.data['dueMileage'] ?? 0;
        var bMileage = b.data['dueMileage'] ?? 0;

        if (aDate == 0 && bDate == 0) {
          // both don't have a date, so only consider the mileages
          if (aMileage > bMileage)
            return 1;
          else if (aMileage < bMileage)
            return -1;
          else
            return 0;
        } else {
          // in case one of the two isn't a valid timestamp
          if (aDate == 0) return -1;
          if (bDate == 0) return 1;
          // consider the dates since all todo items should have dates as a result
          // of the distance rate translation function
          return aDate.compareTo(bDate);
        }
      });
  }

  @override
  Future<void> close() {
    _repeatsSubscription?.cancel();
    return super.close();
  }
}
