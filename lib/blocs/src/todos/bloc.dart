import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:bloc/bloc.dart';

import 'event.dart';
import 'state.dart';
import 'package:autodo/repositories/repositories.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/util.dart';
import '../cars/barrel.dart';
import '../repeating/barrel.dart';
import '../notifications/barrel.dart';
import '../database/barrel.dart';
import 'package:autodo/localization.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  final DatabaseBloc _dbBloc;
  final CarsBloc _carsBloc;
  final NotificationsBloc _notificationsBloc;
  final RepeatsBloc _repeatsBloc;
  StreamSubscription _dataSubscription, _carsSubscription, _repeatsSubscription;
  
  List<Car> _carsCache;

  TodosBloc({
    @required DatabaseBloc dbBloc, 
    @required CarsBloc carsBloc,
    @required NotificationsBloc notificationsBloc,
    @required RepeatsBloc repeatsBloc
  }) : assert(dbBloc != null), assert(carsBloc != null),
       assert(notificationsBloc != null), assert(repeatsBloc != null),
       _dbBloc = dbBloc, _repeatsBloc = repeatsBloc, 
       _carsBloc = carsBloc, _notificationsBloc = notificationsBloc {
    _dataSubscription = _dbBloc.listen((state) {
      if (state is DbLoaded) {
        add(LoadTodos());
      }
    });
    _carsSubscription = _carsBloc.listen( 
      (state) {
        if (state is CarsLoaded) {
          add(UpdateDueDates(state.cars));
        }
      }
    );
    _repeatsSubscription = _repeatsBloc.listen(
      (state) {
        if (state is RepeatsLoaded) {
          add(RepeatsRefresh(state.repeats));
        }
      }
    );
  }

  @override
  TodosState get initialState => TodosLoading();

  DataRepository get repo => (_dbBloc.state is DbLoaded) ? 
    (_dbBloc.state as DbLoaded).repository : null;

  @override
  Stream<TodosState> mapEventToState(TodosEvent event) async* {
    if (event is LoadTodos) {
      yield* _mapLoadTodosToState();
    } else if (event is AddTodo) {
      yield* _mapAddTodoToState(event);
    } else if (event is UpdateTodo) {
      yield* _mapUpdateTodoToState(event);
    } else if (event is DeleteTodo) {
      yield* _mapDeleteTodoToState(event);
    } else if (event is ToggleAll) {
      yield* _mapToggleAllToState();
    } else if (event is UpdateDueDates) {
      yield* _mapUpdateDueDatesToState(event);
    } else if (event is RepeatsRefresh) {
      yield* _mapRepeatsRefreshToState(event);
    } else if (event is CompleteTodo) {
      yield* _mapCompleteTodoToState(event);
    }
  }

  Stream<TodosState> _mapLoadTodosToState() async* {
    try {
      final todos = await repo.todos().first;
      if (todos != null) {
        yield TodosLoaded(todos);
      } else {
        yield TodosNotLoaded();
      }
    } catch (_) {
      yield TodosNotLoaded();
    }
  }

  void _scheduleNotification(Todo todo) {
    _notificationsBloc.add(
      ScheduleNotification(
        date: todo.dueDate,
        title: AutodoLocalizations.todoDueSoon + ': ${todo.name}',
        body: ''
      )
    );
  }

  Todo _updateDueDate(car, todo, batch) {
    var distanceToTodo = todo.dueMileage - car.mileage;
    int daysToTodo = (distanceToTodo / car.distanceRate).round();
    Duration timeToTodo = Duration(days: daysToTodo);
    var newDueDate = roundToDay(car.lastMileageUpdate.toUtc()).add(timeToTodo).toLocal();

    Todo out = todo.copyWith(dueDate: newDueDate, estimatedDueDate: true);
    _notificationsBloc.add(ReScheduleNotification(
      id: out.notificationID,
      date: out.dueDate,
      title: AutodoLocalizations.todoDueSoon + ': ${out.name}',
      body: ''
    ));
    batch.updateData(out.id, out.toEntity().toDocument());
    return out;
  }

  bool _shouldUpdate(car, t) => 
    (t.carName == car.name && (t.estimatedDueDate ?? false) && !(t.completed ?? false));

  Stream<TodosState> _mapUpdateDueDatesToState(UpdateDueDates event) async* {
    List<Car> cars = event.cars;
    if (cars == null || cars.length == 0) return;
    if (state is TodosLoaded && repo != null) {
      TodosLoaded curState = state;
      WriteBatchWrapper batch = repo.startTodoWriteBatch();
      List<Todo> updatedTodos;
      for (var car in cars) {
        if (_carsCache?.contains(car) ?? false) continue;

        updatedTodos = curState.todos
          .map((t) => _shouldUpdate(car, t) ? _updateDueDate(car, t, batch) : t)
          .toList();
      }
      print(event);
      yield TodosLoaded(updatedTodos);
      _carsCache = cars;
      batch.commit();
    }
  }

  Stream<TodosState> _mapAddTodoToState(AddTodo event) async* {
    if (repo == null) return;
    final List<Todo> updatedTodos = List.from((state as TodosLoaded).todos)..add(event.todo);
    yield TodosLoaded(updatedTodos);
    _scheduleNotification(event.todo);
    // out = event.todo.copyWith(notificationID: notificationID);
    repo.addNewTodo(event.todo);
  }

  Stream<TodosState> _mapUpdateTodoToState(UpdateTodo event) async* {
    if (repo == null) return;
    final List<Todo> updatedTodos = (state as TodosLoaded)
      .todos.map((r) => r.id == event.updatedTodo.id ? event.updatedTodo : r)
      .toList();
    yield TodosLoaded(updatedTodos);
    repo.updateTodo(event.updatedTodo);
  }

  Todo _createNewTodoFromRepeat(repeat, todo) {
    CarsLoaded curCarsState = _carsBloc.state;
    Car curCar = curCarsState.cars.firstWhere((c) => c.name == todo.carName);

    int nextDueMileage = curCar.mileage + repeat.mileageInterval;
    int daysToDue = (repeat.mileageInterval / curCar.distanceRate).round();
    DateTime nextDueDate = todo.completedDate.add(Duration(days: daysToDue));
    Todo next = todo.copyWith(
      dueMileage: nextDueMileage,
      dueDate: nextDueDate,
      completed: false
    );
    repo.addNewTodo(next);
    return next;
  }

  Stream<TodosState> _mapCompleteTodoToState(CompleteTodo event) async* {
    Todo curTodo = event.todo;
    if (_repeatsBloc.state is RepeatsLoaded && 
        _carsBloc.state is CarsLoaded && repo != null) {
      List<Todo> updatedTodos = (state as TodosLoaded).todos;

      RepeatsLoaded curRepeatsState = _repeatsBloc.state;
      Repeat curRepeat = curRepeatsState.repeats.firstWhere((r) => r.name == curTodo.repeatName, orElse: () => null);
      if (!curRepeat.props.every((p) => p == null)) {
        Todo newTodo = _createNewTodoFromRepeat(curRepeat, curTodo);
        updatedTodos = updatedTodos..add(newTodo);
        repo.addNewTodo(newTodo);
      }
      
      Todo completedTodo = curTodo.copyWith(
        completed: true, 
        completedDate: event.completedDate ?? DateTime.now(),
      );
      updatedTodos = updatedTodos
        .map((t) => (t.id == completedTodo.id) ? completedTodo : t)
        .toList();
      yield TodosLoaded(updatedTodos);
      repo.updateTodo(completedTodo);
    }
  }

  Stream<TodosState> _mapDeleteTodoToState(DeleteTodo event) async* {
    final updatedTodos = (state as TodosLoaded)
          .todos
          .where((r) => r.id != event.todo.id)
          .toList();
    yield TodosLoaded(updatedTodos);
    repo.deleteTodo(event.todo);
  }

  Stream<TodosState> _mapToggleAllToState() async* {
    final currentState = state;
    if (currentState is TodosLoaded && repo != null) {
      final allComplete = currentState.todos.every((todo) => todo.completed);
      final List<Todo> updatedTodos = currentState.todos
          .map((todo) => todo.copyWith(completed: !allComplete))
          .toList();
      yield TodosLoaded(updatedTodos);
      updatedTodos.forEach((updatedTodo) {
        repo.updateTodo(updatedTodo);
      });
    }
  }

  Stream<TodosState> _mapRepeatsRefreshToState(RepeatsRefresh event) async* {
    // TODO figure out what was/wasn't updated based on metadata?
    // new repeats, updated repeats, and deleted repeats affect this
  }

  List sortItems(List items) {
    return items
      ..sort((a, b) {
        var aDate = a?.dueDate ?? 0;
        var bDate = b?.dueDate ?? 0;
        var aMileage = a?.dueMileage ?? 0;
        var bMileage = b?.dueMileage ?? 0;

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
    _dataSubscription?.cancel();
    _carsSubscription?.cancel();
    _repeatsSubscription?.cancel();
    return super.close();
  }
}
