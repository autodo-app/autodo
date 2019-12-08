import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:bloc/bloc.dart';
import 'event.dart';
import 'state.dart';
import 'package:autodo/repositories/barrel.dart';
import 'package:autodo/models/barrel.dart';

class RefuelingsBloc extends Bloc<RefuelingsEvent, RefuelingsState> {
  final DataRepository _dataRepository;
  StreamSubscription _dataSubscription;

  RefuelingsBloc({@required DataRepository dataRepository})
      : assert(dataRepository != null),
        _dataRepository = dataRepository;

  @override
  RefuelingsState get initialState => RefuelingsLoading();

  @override
  Stream<RefuelingsState> mapEventToState(RefuelingsEvent event) async* {
    if (event is LoadRefuelings) {
      yield* _mapLoadRefuelingsToState();
    } else if (event is AddRefueling) {
      yield* _mapAddRefuelingToState(event);
    } else if (event is UpdateRefueling) {
      yield* _mapUpdateRefuelingToState(event);
    } else if (event is DeleteRefueling) {
      yield* _mapDeleteRefuelingToState(event);
    } else if (event is RefuelingsUpdated) {
      yield* _mapRefuelingsUpdateToState(event);
    }
  }

  Stream<RefuelingsState> _mapLoadRefuelingsToState() async* {
    _dataSubscription?.cancel();
    _dataSubscription = _dataRepository.refuelings().listen(
          (refuelings) => add(RefuelingsUpdated(refuelings)),
        );
  }

  Stream<RefuelingsState> _mapAddRefuelingToState(AddRefueling event) async* {
    _dataRepository.addNewRefueling(event.todo);
  }

  Stream<RefuelingsState> _mapUpdateRefuelingToState(UpdateRefueling event) async* {
    _dataRepository.updateRefueling(event.updatedRefueling);
  }

  Stream<RefuelingsState> _mapDeleteRefuelingToState(DeleteRefueling event) async* {
    _dataRepository.deleteRefueling(event.todo);
  }

  Stream<RefuelingsState> _mapRefuelingsUpdateToState(RefuelingsUpdated event) async* {
    yield RefuelingsLoaded(event.todos);
  }

  @override
  Future<void> close() {
    _dataSubscription?.cancel();
    return super.close();
  }
}
