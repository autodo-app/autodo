import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import '../../../generated/localization.dart';
import '../../../models/models.dart';
import '../../../repositories/repositories.dart';
import '../../../units/units.dart';
import '../../../util.dart';
import '../database/barrel.dart';
import '../notifications/barrel.dart';
import 'default_todos.dart';
import 'event.dart';
import 'state.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  DataBloc({@required this.dbBloc, @required this.notificationsBloc})
      : assert(dbBloc != null),
        assert(notificationsBloc != null) {
    _dbSubscription = dbBloc.listen((state) {
      if (state is DbLoaded) {
        add(LoadData());
      }
    });
  }

  final DatabaseBloc dbBloc;

  final NotificationsBloc notificationsBloc;

  StreamSubscription _dbSubscription;

  @override
  DataState get initialState => DataLoading();

  DataRepository get repo =>
      (dbBloc.state is DbLoaded) ? (dbBloc.state as DbLoaded).dataRepo : null;

  @override
  Stream<DataState> mapEventToState(DataEvent event) async* {
    if (event is LoadData) {
      yield* _mapLoadDataToState(event);
    } else if (event is TranslateDefaults) {
      yield* _mapTranslateDefaultsToState(event);
    }

    // If we're operating on existing data then ensure that everything is loaded
    // first.
    if (!(state is DataLoaded) || repo == null) {
      print('Cannot update uninitialized DataBloc');
      return;
    }

    if (event is AddTodo) {
      yield* _mapAddTodoToState(event);
    } else if (event is UpdateTodo) {
      yield* _mapUpdateTodoToState(event);
    } else if (event is DeleteTodo) {
      yield* _mapDeleteTodoToState(event);
    } else if (event is AddRefueling) {
      yield* _mapAddRefuelingToState(event);
    } else if (event is UpdateRefueling) {
      yield* _mapUpdateRefuelingToState(event);
    } else if (event is DeleteRefueling) {
      yield* _mapDeleteRefuelingToState(event);
    } else if (event is AddCar) {
      yield* _mapAddCarToState(event);
    } else if (event is UpdateCar) {
      yield* _mapUpdateCarToState(event);
    } else if (event is DeleteCar) {
      yield* _mapDeleteCarToState(event);
    } else if (event is CompleteTodo) {
      yield* _mapCompleteTodoToState(event);
    } else if (event is ToggleAllTodosComplete) {
      yield* _mapToggleAllTodosToState(event);
    }
  }

  /// Calculates the Due Date for a ToDo based on the given car's distanceRate.
  static DateTime calcDueDate(Car car, double dueMileage) {
    if (car.distanceRate == 0 || car.distanceRate == null) {
      return null;
    }

    final distanceToTodo = dueMileage - car.odomSnapshot.mileage;
    var daysToTodo = 0; // TODO: Needs proper fix
    try {
      daysToTodo = (distanceToTodo / car.distanceRate).round();
    } catch (e) {
      print(e);
    }
    final timeToTodo = Duration(days: daysToTodo);
    return roundToDay(car.odomSnapshot.date.toUtc()).add(timeToTodo).toLocal();
  }

  /// Returns a TodoDueState enum value describing the proximity to the ToDo's deadline.
  static TodoDueState calcDueState(Car car, Todo todo) {
    if (todo.completed ?? false) {
      return TodoDueState.COMPLETE;
    } else if (car.odomSnapshot.mileage - todo.dueMileage > 0) {
      return TodoDueState.PAST_DUE;
    } else if (DateTime.now().isAfter(todo.dueDate)) {
      return TodoDueState.PAST_DUE;
    }

    final distanceRate =
        car.distanceRate ?? DEFAULT_DUE_SOON_CUTOFF_DISTANCE_RATE;
    final daysUntilDueMileage =
        ((todo.dueMileage - car.odomSnapshot.mileage) * distanceRate).round();
    // Truncating rather than rounding here, that should hopefully be fine though
    final daysUntilDueDate = todo.dueDate.difference(DateTime.now()).inDays;

    if ((daysUntilDueMileage < DUE_SOON_CUTOFF_TIME) ||
        daysUntilDueDate < DUE_SOON_CUTOFF_TIME) {
      return TodoDueState.DUE_SOON;
    }
    return TodoDueState.UPCOMING;
  }

  /// Updates the cars and todos based on a change to the odom snapshots.
  Stream<DataState> _reactToOdomSnapshotChange(OdomSnapshot snapshot) async* {
    var car =
        (state as DataLoaded).cars.firstWhere((c) => c.id == snapshot.car);
    if (snapshot.mileage > car.odomSnapshot.mileage) {
      // This refueling is newer than the latest for the car, update the car's mileage
      car = car.copyWith(odomSnapshot: snapshot);
      final updatedCar = await repo.updateCar(car);
      final updatedCarList = List.from((state as DataLoaded).cars)
        ..map((c) => c.id == updatedCar.id ? updatedCar : c);
      yield (state as DataLoaded).copyWith(cars: updatedCarList);

      // update the car's efficiency and distance rate
      // individual efficiency values should probably only be handled in the stats bloc

      // Update the todos' dueState values based on the car's new mileage
      final updatedTodos = (state as DataLoaded).todos.map((t) =>
          (t.carId == car.id)
              ? t.copyWith(dueState: calcDueState(updatedCar, t))
              : t);
      for (var t in updatedTodos) {
        await repo.updateTodo(t);
      }

      // update the todos' estimated due dates based on the car's new distanceRate
      yield (state as DataLoaded).copyWith(todos: updatedTodos);
    }
  }

  Stream<DataState> _mapLoadDataToState(LoadData event) async* {
    try {
      final cars = await repo
          .getCurrentCars()
          .timeout(Duration(seconds: 1), onTimeout: () => []);
      final refuelings = await repo
          .getCurrentRefuelings()
          .timeout(Duration(seconds: 1), onTimeout: () => []);
      final todos = await repo
          .getCurrentTodos()
          .timeout(Duration(seconds: 1), onTimeout: () => []);

      if (cars != null && refuelings != null && todos != null) {
        yield DataLoaded(cars: cars, refuelings: refuelings, todos: todos);
      } else {
        yield DataLoaded();
      }
    } catch (e) {
      print(e);
      yield DataNotLoaded();
    }
  }

  bool _shouldEstimateDueDate(t) =>
      (t.estimatedDueDate ?? true) && !(t.completed ?? false);

  Stream<DataState> _mapAddTodoToState(AddTodo event) async* {
    var todo = event.todo;
    final car =
        (state as DataLoaded).cars.firstWhere((c) => c.id == todo.carId);

    if (_shouldEstimateDueDate(todo)) {
      // set an estimated due date for the todo
      final newDate = calcDueDate(car, todo.dueMileage);
      todo = todo.copyWith(dueDate: newDate, estimatedDueDate: true);
    }

    if (todo.completed ?? false) {
      // The todo has an odom snapshot attached
      // Write it to the database
      final updatedOdomSnapshot =
          await repo.addNewOdomSnapshot(todo.completedOdomSnapshot);
      todo = todo.copyWith(completedOdomSnapshot: updatedOdomSnapshot);

      // update related models
      yield* _reactToOdomSnapshotChange(todo.completedOdomSnapshot);
    }

    // Schedule a notification
    // TODO: how to get the ID back from this?
    notificationsBloc.add(ScheduleNotification(
        date: todo.dueDate,
        title: '${IntlKeys.todoDueSoon}: ${todo.name}', // TODO: Translate this
        body: ''));

    final newTodo = await repo.addNewTodo(todo);
    final updatedTodos = List.from((state as DataLoaded).todos)..add(newTodo);
    yield (state as DataLoaded).copyWith(todos: updatedTodos);
  }

  Stream<DataState> _mapUpdateTodoToState(UpdateTodo event) async* {
    var todo = event.todo;
    final car =
        (state as DataLoaded).cars.firstWhere((c) => c.id == todo.carId);

    if (_shouldEstimateDueDate(todo)) {
      // set an estimated due date for the todo
      final newDate = calcDueDate(car, todo.dueMileage);
      todo = todo.copyWith(dueDate: newDate, estimatedDueDate: true);
    }

    if (todo.completed ?? false) {
      // The todo has an odom snapshot attached
      // Write it to the database
      final updatedOdomSnapshot =
          await repo.addNewOdomSnapshot(todo.completedOdomSnapshot);
      todo = todo.copyWith(completedOdomSnapshot: updatedOdomSnapshot);

      // update related models
      yield* _reactToOdomSnapshotChange(todo.completedOdomSnapshot);
    }

    notificationsBloc.add(ReScheduleNotification(
        id: todo.notificationID,
        date: todo.dueDate,
        title: '${IntlKeys.todoDueSoon}: ${todo.name}', // TODO: Translate this
        body: ''));

    final updatedTodo = await repo.updateTodo(todo);
    final updatedTodos = List.from((state as DataLoaded).todos)
      ..map((t) => (t.id == updatedTodo.id) ? updatedTodo : t);
    yield (state as DataLoaded).copyWith(todos: updatedTodos);
  }

  Stream<DataState> _mapDeleteTodoToState(DeleteTodo event) async* {
    await repo.deleteTodo(event.todo);
    final updatedTodos = List.from((state as DataLoaded).todos)
      ..remove(event.todo);
    yield (state as DataLoaded).copyWith(todos: updatedTodos);
  }

  Stream<DataState> _mapCompleteTodoToState(CompleteTodo event) async* {
    var todo = event.todo;
    final car =
        (state as DataLoaded).cars.firstWhere((c) => c.id == todo.carId);
    final curCarMileage = event.completedMileage ?? car.odomSnapshot.mileage;

    // Update the todos' fields
    todo = todo.copyWith(
      completed: true,
      completedOdomSnapshot: OdomSnapshot(
        car: todo.carId,
        date: event.completedDate ?? DateTime.now(),
        mileage: curCarMileage,
      ),
    );

    // Assuming that this is the first time that the completedOdomSnapshot is present
    // Write it to the database and update related models
    final updatedOdomSnapshot =
        await repo.addNewOdomSnapshot(todo.completedOdomSnapshot);
    todo = todo.copyWith(completedOdomSnapshot: updatedOdomSnapshot);
    yield* _reactToOdomSnapshotChange(todo.completedOdomSnapshot);

    // Write the updated todo to the database
    final updatedTodo = await repo.updateTodo(todo);
    final updatedTodoList = (state as DataLoaded)
        .todos
        .map((t) => (t.id == updatedTodo.id) ? updatedTodo : t);
    yield (state as DataLoaded).copyWith(todos: updatedTodoList);

    // Create the next ToDo if there's a repeating interval specified
    if (todo.mileageRepeatInterval != null) {
      final newDueMileage = curCarMileage + todo.mileageRepeatInterval;
      // Creating a new one instead of .copyWith() so that null fields are
      // preserved
      final newTodo = Todo(
        name: todo.name,
        carId: todo.carId,
        dueMileage: newDueMileage,
        mileageRepeatInterval: todo.mileageRepeatInterval,
        estimatedDueDate: true,
        dueDate: calcDueDate(car, newDueMileage),
        completed: false,
      );

      // Write to database
      final updatedTodo = await repo.addNewTodo(newTodo);
      final updatedTodoList = List.from((state as DataLoaded).todos)
        ..add(updatedTodo);
      yield (state as DataLoaded).copyWith(todos: updatedTodoList);
    }
  }

  /// Goes through each of the currently active todos and marks them as complete
  Stream<DataState> _mapToggleAllTodosToState(
      ToggleAllTodosComplete event) async* {
    for (var t in (state as DataLoaded).todos) {
      if (!t.completed ?? true) {
        // Complete the todo
        yield* _mapCompleteTodoToState(CompleteTodo(todo: t));
      }
    }
  }

  Stream<DataState> _mapAddRefuelingToState(AddRefueling event) async* {
    final refueling = event.refueling;

    // Write Odom Snapshot to Database
    final newOdomSnapshot =
        await repo.addNewOdomSnapshot(refueling.odomSnapshot);
    final refuelingWithOdomSnapshotId =
        refueling.copyWith(odomSnapshot: newOdomSnapshot);
    yield* _reactToOdomSnapshotChange(newOdomSnapshot);

    // Write the Refueling to Database
    final newRefueling =
        await repo.addNewRefueling(refuelingWithOdomSnapshotId);
    final updatedRefuelings = List.from((state as DataLoaded).refuelings)
      ..add(newRefueling);
    yield (state as DataLoaded).copyWith(refuelings: updatedRefuelings);
  }

  Stream<DataState> _mapUpdateRefuelingToState(UpdateRefueling event) async* {
    var updatedRefueling = event.refueling;
    final curRefueling = (state as DataLoaded)
        .refuelings
        .firstWhere((r) => r.id == updatedRefueling.id);

    if (updatedRefueling.odomSnapshot != curRefueling.odomSnapshot) {
      // OdomSnapshot changed, write it to db and update related models
      final updatedOdomSnapshot =
          await repo.updateOdomSnapshot(updatedRefueling.odomSnapshot);
      updatedRefueling =
          updatedRefueling.copyWith(odomSnapshot: updatedOdomSnapshot);
      yield* _reactToOdomSnapshotChange(updatedOdomSnapshot);
    }

    // Write Refueling to Database
    updatedRefueling = await repo.updateRefueling(updatedRefueling);
    final updatedRefuelings = List.from((state as DataLoaded).refuelings)
      ..map((r) => (r.id == updatedRefueling.id) ? updatedRefueling : r);
    yield (state as DataLoaded).copyWith(refuelings: updatedRefuelings);
  }

  Stream<DataState> _mapDeleteRefuelingToState(DeleteRefueling event) async* {
    // Check if this refueling is the latest for the car and update the car/todos if so
    // TODO: see what the delete cascading will look like on the server
    await repo.deleteRefueling(event.refueling);
    final updatedRefuelings = List.from((state as DataLoaded).refuelings)
      ..remove(event.refueling);
    yield (state as DataLoaded).copyWith(refuelings: updatedRefuelings);
  }

  Stream<DataState> _mapAddCarToState(AddCar event) async* {
    var car = event.car;

    // handle new odom snapshot and reactions
    final updatedOdomSnapshot = await repo.addNewOdomSnapshot(car.odomSnapshot);
    car = car.copyWith(odomSnapshot: updatedOdomSnapshot);
    yield* _reactToOdomSnapshotChange(updatedOdomSnapshot);

    // add the car
    final newCar = await repo.addNewCar(car);
    final updatedCars = List.from((state as DataLoaded).cars)..add(newCar);
    yield (state as DataLoaded).copyWith(cars: updatedCars);

    // add the default todos
    final updatedTodoList = List.from((state as DataLoaded).todos);
    final newCarMileage = newCar.odomSnapshot.mileage;
    for (var t in (state as DataLoaded).defaultTodos) {
      final dueMileage = (t.mileageRepeatInterval < newCarMileage)
          ? (newCarMileage + t.mileageRepeatInterval)
          : t.mileageRepeatInterval;
      final newTodo = t.copyWith(
        carId: newCar.id,
        dueMileage: dueMileage,
      );
      final updatedTodo = await repo.addNewTodo(newTodo);
      updatedTodoList.add(updatedTodo);
    }
    yield (state as DataLoaded).copyWith(todos: updatedTodoList);
  }

  Stream<DataState> _mapUpdateCarToState(UpdateCar event) async* {
    var newCar = event.car;
    final oldCar =
        (state as DataLoaded).cars.firstWhere((c) => c.id == newCar.id);
    if (newCar.odomSnapshot != oldCar.odomSnapshot) {
      // odom snapshot has changed, write the change to db
      final updatedOdomSnapshot =
          await repo.updateOdomSnapshot(newCar.odomSnapshot);
      newCar = newCar.copyWith(odomSnapshot: updatedOdomSnapshot);
      yield* _reactToOdomSnapshotChange(updatedOdomSnapshot);
    }

    final updatedCar = await repo.updateCar(newCar);
    final updatedCars = List.from((state as DataLoaded).cars)
      ..map((c) => (c.id == updatedCar.id) ? updatedCar : c);
    yield (state as DataLoaded).copyWith(cars: updatedCars);
  }

  Stream<DataState> _mapDeleteCarToState(DeleteCar event) async* {
    // TODO: see if the todos/refuelings/odomsnapshots for the car will be deleted by server here
    await repo.deleteCar(event.car);
    final updatedCars = List.from((state as DataLoaded).cars)
      ..remove(event.car);
    yield (state as DataLoaded).copyWith(cars: updatedCars);
  }

  Stream<DataState> _mapTranslateDefaultsToState(
      TranslateDefaults event) async* {
    List<Todo> translated;

    // Get the correct set of defaults so the intervals are nice, round numbers
    if (event.distanceUnit == DistanceUnit.imperial) {
      translated = List<Todo>.from(defaultsImperial);
    } else if (event.distanceUnit == DistanceUnit.metric) {
      translated = List<Todo>.from(defaultsMetric);
    }

    // Translate the names
    translated = translated
        .map((t) => t.copyWith(name: event.jsonIntl.get(t.name)))
        .toList();
    if (state is DataLoading) {
      yield DataLoading(defaultTodos: translated);
    } else if (state is DataLoaded) {
      yield (state as DataLoaded).copyWith(defaultTodos: translated);
    }
  }

  @override
  void onTransition(dynamic transition) {
    print('*****************************************');
    print('**   onTransition $transition');
    print('*****************************************');
  }

  @override
  Future<void> close() async {
    await _dbSubscription?.cancel();
    return super.close();
  }
}
