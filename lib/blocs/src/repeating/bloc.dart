import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:bloc/bloc.dart';

import 'package:autodo/repositories/repositories.dart';
import 'package:autodo/models/models.dart';
import '../database/barrel.dart';
import 'event.dart';
import 'state.dart';

class RepeatsBloc extends Bloc<RepeatsEvent, RepeatsState> {
  final DatabaseBloc _dbBloc;
  StreamSubscription _dbSubscription;

  static final List<Repeat> defaults = [
    Repeat(name: "oil", mileageInterval: 3500),
    Repeat(name: "tireRotation", mileageInterval: 7500),
    Repeat(name: "engineFilter", mileageInterval: 45000),
    Repeat(name: "wiperBlades", mileageInterval: 30000),
    Repeat(name: "alignmentCheck", mileageInterval: 40000),
    Repeat(name: "cabinFilter", mileageInterval: 45000),
    Repeat(name: "tires", mileageInterval: 50000),
    Repeat(name: "brakes", mileageInterval: 60000),
    Repeat(name: "sparkPlugs", mileageInterval: 60000),
    Repeat(name: "frontStruts", mileageInterval: 75000),
    Repeat(name: "rearStruts", mileageInterval: 75000),
    Repeat(name: "battery", mileageInterval: 75000),
    Repeat(name: "serpentineBelt", mileageInterval: 150000),
    Repeat(name: "transmissionFluid", mileageInterval: 100000),
    Repeat(name: "coolantChange", mileageInterval: 100000)
  ];

  RepeatsBloc({@required DatabaseBloc dbBloc})
      : assert(dbBloc != null), _dbBloc = dbBloc {
    _dbSubscription = _dbBloc.listen((state) {
      if (state is DbLoaded) {
        add(LoadRepeats());
      }
    });
  }

  @override
  RepeatsState get initialState => RepeatsLoading();

  DataRepository get repo => (_dbBloc.state is DbLoaded) ? 
    (_dbBloc.state as DbLoaded).repository : null;

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
    } else if (event is AddDefaultRepeats) {
      yield* _mapAddDefaultRepeatsToState(event);
    }
  }

  Stream<RepeatsState> _mapLoadRepeatsToState() async* {
    try {
      final repeats = await repo.repeats().first;
      if (repeats != null) {
        yield RepeatsLoaded(repeats);
      } else {
        yield RepeatsNotLoaded();
      }
    } catch (_) {
      yield RepeatsNotLoaded();
    }
  }

  Stream<RepeatsState> _mapAddRepeatToState(AddRepeat event) async* {
    if (state is RepeatsLoaded && repo != null) {
      final List<Repeat> updatedRepeats = List.from((state as RepeatsLoaded).repeats)..add(event.repeat);
      yield RepeatsLoaded(updatedRepeats);
      repo.addNewRepeat(event.repeat);
    }
  }

  Stream<RepeatsState> _mapUpdateRepeatToState(UpdateRepeat event) async* {
    if (state is RepeatsLoaded && repo != null) {
      final List<Repeat> updatedRepeats = (state as RepeatsLoaded).repeats
        .map((r) => r.id == event.updatedRepeat.id ? event.updatedRepeat : r)
        .toList();
      yield RepeatsLoaded(updatedRepeats);
      repo.updateRepeat(event.updatedRepeat);
    }
  }

  Stream<RepeatsState> _mapDeleteRepeatToState(DeleteRepeat event) async* {
    if (state is RepeatsLoaded && repo != null) {
      final updatedRepeats = (state as RepeatsLoaded).repeats
        .where((r) => r.id != event.repeat.id)
        .toList();
      yield RepeatsLoaded(updatedRepeats);
      repo.deleteRepeat(event.repeat);
    }
  }

  /// Finds a Map of the last completed todo in the repeating
  /// task categories.
  // Future<void> _findLatestCompletedTodos(List<Repeat> repeats) async {
  //   Query completes = userDoc
  //       .collection('todos')
  //       .where("complete", isEqualTo: true)
  //       .where("tags", arrayContains: car)
  //       .orderBy("completeDate");
  //   QuerySnapshot docs = await completes.getDocuments();
  //   List<DocumentSnapshot> snaps = docs.documents;

  //   for (var r in repeats) {
  //     String taskType = r.name;
  //     if (!_keyInRepeats(taskType)) return;
  //     // Initialize the Map if it is a new car
  //     if (latestCompletedRepeatTodos[car] == null)
  //       latestCompletedRepeatTodos[car] = {};
  //     if (!latestCompletedRepeatTodos[car].containsKey(taskType))
  //       latestCompletedRepeatTodos[car][taskType] = snap.data;
  //   });
  // }

  // /// Finds a Map of upcoming todo items in the repeating
  // /// task categories.
  // Future<void> _findUpcomingRepeatTodos(String car) async {
  //   DocumentReference userDoc = FirestoreBLoC().getUserDocument();
  //   Query completes = userDoc
  //       .collection('todos')
  //       .where("complete", isEqualTo: false)
  //       .where("tags", arrayContains: car)
  //       .orderBy("completeDate");
  //   QuerySnapshot docs = await completes.getDocuments();
  //   List<DocumentSnapshot> snaps = docs.documents;

  //   snaps.forEach((snap) {
  //     String taskType = snap.data['repeatingType'];
  //     if (!_keyInRepeats(taskType)) return;
  //     if (upcomingRepeatTodos[car] == null) upcomingRepeatTodos[car] = {};
  //     if (!upcomingRepeatTodos[car].containsKey(taskType))
  //       upcomingRepeatTodos[car][taskType] = snap.data;
  //   });
  // }

  // // Find latest completed todos with ties to a repeat
  // // Determine if the completed todo has an upcoming todo already
  // // if not, find the interval for the todo and add that to the mileage where the completed todo ocurred
  // // create new todo with that information
  // Future<void> updateUpcomingTodos() async {
  //   await _checkForRepeats();

  //   List<Car> cars = await CarsBLoC().getCars();
  //   cars.forEach((car) async {
  //     await _findLatestCompletedTodos(car.name);
  //     await _findUpcomingRepeatTodos(car.name);
  //     repeats.forEach((repeat) {
  //       if (repeat == null) return;
  //       // Check if the upcoming ToDo for this category already exists
  //       if (upcomingRepeatTodos[car.name] == null ||
  //           !upcomingRepeatTodos[car.name].containsKey(repeat.name)) {
  //         int newDueMileage = repeat.interval;
  //         if (latestCompletedRepeatTodos[car.name] != null &&
  //             latestCompletedRepeatTodos[car.name].keys.contains(repeat.name)) {
  //           // If a ToDo in this category has already been completed, use that as
  //           // the base for extrapolating the dueMileage for the new ToDo
  //           newDueMileage += latestCompletedRepeatTodos[car.name][repeat.name]
  //               ['completedMileage'];
  //         } else if (newDueMileage < (car.mileage * 0.75)) {
  //           // Add the repeat interval to the car's current mileage if the small
  //           // interval and high mileage makes it seem unlikely that the car
  //           // has not had this operation done at some point
  //           newDueMileage += car.mileage;
  //         }
  //         pushNewTodo(car.name, repeat.name, newDueMileage, false);
  //       }
  //     });
  //   });
  // }

  Stream<RepeatsState> _mapAddDefaultRepeatsToState(AddDefaultRepeats event) async* {
    yield RepeatsLoaded(defaults);
    if (repo == null) return;
    WriteBatchWrapper batch = repo.startRepeatWriteBatch();
    for (var r in defaults) {
      batch.setData(r.toEntity().toDocument());
    }
    batch.commit();
  }

  // List sortItems(List items) {
  //   return items
  //     ..sort((a, b) {
  //       var aDate = a.data['dueDate'] ?? 0;
  //       var bDate = b.data['dueDate'] ?? 0;
  //       var aMileage = a.data['dueMileage'] ?? 0;
  //       var bMileage = b.data['dueMileage'] ?? 0;

  //       if (aDate == 0 && bDate == 0) {
  //         // both don't have a date, so only consider the mileages
  //         if (aMileage > bMileage)
  //           return 1;
  //         else if (aMileage < bMileage)
  //           return -1;
  //         else
  //           return 0;
  //       } else {
  //         // in case one of the two isn't a valid timestamp
  //         if (aDate == 0) return -1;
  //         if (bDate == 0) return 1;
  //         // consider the dates since all todo items should have dates as a result
  //         // of the distance rate translation function
  //         return aDate.compareTo(bDate);
  //       }
  //     });
  // }

  @override
  Future<void> close() {
    _dbSubscription?.cancel();
    return super.close();
  }
}
