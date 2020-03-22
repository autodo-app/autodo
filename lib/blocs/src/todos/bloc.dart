import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:bloc/bloc.dart';

import 'event.dart';
import 'state.dart';
import 'package:autodo/repositories/repositories.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/util.dart';
import '../cars/barrel.dart';
import '../notifications/barrel.dart';
import '../database/barrel.dart';
import 'package:autodo/generated/localization.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  TodosBloc(
      {@required DatabaseBloc dbBloc,
      @required CarsBloc carsBloc,
      @required NotificationsBloc notificationsBloc})
      : assert(dbBloc != null),
        assert(carsBloc != null),
        assert(notificationsBloc != null),
        _dbBloc = dbBloc,
        _carsBloc = carsBloc,
        _notificationsBloc = notificationsBloc {
    _dataSubscription = _dbBloc.listen((state) {
      if (state is DbLoaded) {
        print('loaded $repo   ${repo.todos()}');
        add(LoadTodos());
        _repoSubscription = repo?.todos()?.listen((event) {
          add(LoadTodos());
        });
      }
    });
    _carsSubscription = _carsBloc.listen((state) {
      if (state is CarsLoaded) {
        add(UpdateDueDates(state.cars));
      }
    });
  }

  final DatabaseBloc _dbBloc;

  final CarsBloc _carsBloc;

  final NotificationsBloc _notificationsBloc;


  StreamSubscription _dataSubscription,
      _carsSubscription,
      _repoSubscription;

  List<Car> _carsCache;

  @override
  TodosState get initialState => TodosLoading();

  DataRepository get repo => (_dbBloc.state is DbLoaded)
      ? (_dbBloc.state as DbLoaded).repository
      : null;

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
    } else if (event is CompleteTodo) {
      yield* _mapCompleteTodoToState(event);
    }
  }

  Stream<TodosState> _mapLoadTodosToState() async* {
    try {
      final todos = await repo
          .getCurrentTodos()
          .timeout(Duration(seconds: 10), onTimeout: () => []);
      if (todos != null) {
        yield TodosLoaded(todos);
      } else {
        yield TodosLoaded([]);
      }
    } catch (e) {
      print('Error loading todos: $e');
      yield TodosNotLoaded();
    }
  }

  void _scheduleNotification(Todo todo) {
    _notificationsBloc.add(ScheduleNotification(
        date: todo.dueDate,
        title: '${IntlKeys.todoDueSoon}: ${todo.name}', // TODO: Translate this
        body: ''));
  }

  Todo _updateDueDate(car, todo, batch) {
    final distanceToTodo = todo.dueMileage - car.mileage;
    final int daysToTodo = (distanceToTodo / car.distanceRate).round();
    final timeToTodo = Duration(days: daysToTodo);
    final newDueDate =
        roundToDay(car.lastMileageUpdate.toUtc()).add(timeToTodo).toLocal();

    final Todo out = todo.copyWith(dueDate: newDueDate, estimatedDueDate: true);
    _notificationsBloc.add(ReScheduleNotification(
        id: out.notificationID,
        date: out.dueDate,
        title: '${IntlKeys.todoDueSoon}: ${out.name}', // TODO: Translate this
        body: ''));
    batch.updateData(out.id, out.toDocument());
    return out;
  }

  bool _shouldUpdate(car, t) =>
      t.carName == car.name &&
      (t.estimatedDueDate ?? false) &&
      !(t.completed ?? false);

  Stream<TodosState> _mapUpdateDueDatesToState(UpdateDueDates event) async* {
    final cars = event.cars;
    if (cars == null ||
        cars.isEmpty ||
        !(state is TodosLoaded) ||
        repo == null) {
      return;
    }

    final TodosLoaded curState = state;
    final batch = await repo.startTodoWriteBatch();
    List<Todo> updatedTodos;
    for (var car in cars) {
      if (_carsCache?.contains(car) ?? false) continue;

      updatedTodos = curState.todos
          .map((t) => _shouldUpdate(car, t) ? _updateDueDate(car, t, batch) : t)
          .toList();
      yield TodosLoaded(updatedTodos);
      _carsCache = cars;
      await batch.commit();
    }
  }

  Stream<TodosState> _mapAddTodoToState(AddTodo event) async* {
    if (repo == null) {
      print('Error: adding todo to null repo');
      return;
    }
    final updatedTodos = List<Todo>.from((state as TodosLoaded).todos)
      ..add(event.todo);
    yield TodosLoaded(updatedTodos);
    _scheduleNotification(event.todo);
    await repo.addNewTodo(event.todo);
  }

  Stream<TodosState> _mapUpdateTodoToState(UpdateTodo event) async* {
    if (repo == null) {
      print('Error: updating todo with null repo');
      return;
    }
    final updatedTodos = (state as TodosLoaded).todos.map<Todo>((r) {
      if (r.id != null && event.updatedTodo.id != null) {
        return r.id == event.updatedTodo.id ? event.updatedTodo : r;
      } else {
        return (r.name == event.updatedTodo.name) ? event.updatedTodo : r;
      }
    }).toList();
    yield TodosLoaded(updatedTodos);
    await repo.updateTodo(event.updatedTodo);
  }

  Stream<TodosState> _mapCompleteTodoToState(CompleteTodo event) async* {
    final curTodo = event.todo;
    if (_carsBloc.state is CarsLoaded &&
        repo != null) {
      var updatedTodos = (state as TodosLoaded).todos;

      // TODO 275: add a new todp here if its interval aren't null
      // final RepeatsLoaded curRepeatsState = _repeatsBloc.state;
      // final curRepeat = curRepeatsState.repeats
      //     .firstWhere((r) => r.name == curTodo.repeatName, orElse: () => null);
      // if (!curRepeat.props.every((p) => p == null)) {
      //   final newTodo = _createNewTodoFromRepeat(curRepeat, curTodo);
      //   updatedTodos = updatedTodos..add(newTodo);
      //   await repo.addNewTodo(newTodo);
      // }

      final completedTodo = curTodo.copyWith(
        completed: true,
        completedDate: event.completedDate ?? DateTime.now(),
      );
      updatedTodos = updatedTodos
          .map((t) => (t.id == completedTodo.id) ? completedTodo : t)
          .toList();
      yield TodosLoaded(updatedTodos);
      await repo.updateTodo(completedTodo);
    }
  }

  Stream<TodosState> _mapDeleteTodoToState(DeleteTodo event) async* {
    final updatedTodos = (state as TodosLoaded).todos.where((r) {
      if (r.id != null && event.todo.id != null) {
        return r.id != event.todo.id;
      } else {
        return r.name != event.todo.name;
      }
    }).toList();
    yield TodosLoaded(updatedTodos);
    await repo.deleteTodo(event.todo);
  }

  Stream<TodosState> _mapToggleAllToState() async* {
    final currentState = state;
    if (currentState is TodosLoaded && repo != null) {
      final allComplete = currentState.todos.every((todo) => todo.completed);
      final updatedTodos = currentState.todos
          .map<Todo>((todo) => todo.copyWith(completed: !allComplete))
          .toList();
      yield TodosLoaded(updatedTodos);
      final batch = await repo.startTodoWriteBatch();
      updatedTodos.forEach((updatedTodo) {
        batch.updateData(updatedTodo.id, updatedTodo.toDocument());
      });
      await batch.commit();
    }
  }

  // Stream<TodosState> _mapRepeatsRefreshToState(RepeatsRefresh event) async* {
  //   // TODO figure out what was/wasn't updated based on metadata?
  //   // new repeats, updated repeats, and deleted repeats affect this
  //   // TODO currently not removing todos with a deleted repeat
  //   final todos = (state is TodosLoaded) ? (state as TodosLoaded).todos : [];
  //   final cars = (_carsBloc.state as CarsLoaded).cars;
  //   final batch = await repo.startTodoWriteBatch();
  //   for (var r in event.repeats) {
  //     if (todos.isNotEmpty && todos.any((t) => _todoIsOpenForRepeat(t, r))) {
  //       // there is already an open todo for this repeat so redo the durMileage
  //       // calc
  //       final Todo upcoming =
  //           todos.firstWhere((t) => _todoIsOpenForRepeat(t, r));
  //       final updated = upcoming.copyWith(
  //           dueMileage: _calculateNextTodo(
  //               todos.where((t) => t.repeatName == r.name).toList(),
  //               r.mileageInterval));

  //       batch.updateData(updated.id, updated.toDocument());
  //     } else {
  //       // create a new todo for the repeat
  //       final c = cars.firstWhere((c) => c.name == r.cars[0]);
  //       final dueMileage = (r.mileageInterval > c.mileage)
  //           ? r.mileageInterval
  //           : c.mileage + r.mileageInterval;
  //       final upcoming = Todo(
  //           name: r.name,
  //           carName: c.name,
  //           repeatName: r.name,
  //           dueMileage: dueMileage,
  //           completed: false);
  //       batch.setData(upcoming.toDocument());
  //     }
  //   }
  //   await batch.commit();
  //   final updatedTodos = await repo.getCurrentTodos();
  //   yield TodosLoaded(updatedTodos);
  // }

  @override
  Future<void> close() {
    _dataSubscription?.cancel();
    _carsSubscription?.cancel();
    _repoSubscription?.cancel();
    return super.close();
  }
}
