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
  TodosBloc(
      {@required DatabaseBloc dbBloc,
      @required CarsBloc carsBloc,
      @required NotificationsBloc notificationsBloc,
      @required RepeatsBloc repeatsBloc})
      : assert(dbBloc != null),
        assert(carsBloc != null),
        assert(notificationsBloc != null),
        assert(repeatsBloc != null),
        _dbBloc = dbBloc,
        _repeatsBloc = repeatsBloc,
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
    _repeatsSubscription = _repeatsBloc.listen((state) {
      print(state);
      if (state is RepeatsLoaded) {
        add(RepeatsRefresh(state.repeats));
      }
    });
  }

  final DatabaseBloc _dbBloc;

  final CarsBloc _carsBloc;

  final NotificationsBloc _notificationsBloc;

  final RepeatsBloc _repeatsBloc;

  StreamSubscription _dataSubscription,
      _carsSubscription,
      _repeatsSubscription,
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
    } else if (event is RepeatsRefresh) {
      yield* _mapRepeatsRefreshToState(event);
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
    batch.updateData(out.id, out.toEntity().toDocument());
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
    print('todos now: ${(state as TodosLoaded).todos}');
    final updatedTodos = (state as TodosLoaded).todos.map<Todo>((r) {
      if (r.id != null && event.updatedTodo.id != null) {
        return r.id == event.updatedTodo.id ? event.updatedTodo : r;
      } else {
        return (r.name == event.updatedTodo.name) ? event.updatedTodo : r;
      }
    }).toList();
    yield TodosLoaded(updatedTodos);
    print('todos then: $updatedTodos');
    await repo.updateTodo(event.updatedTodo);
  }

  Todo _createNewTodoFromRepeat(repeat, todo) {
    final CarsLoaded curCarsState = _carsBloc.state;
    final curCar = curCarsState.cars.firstWhere((c) => c.name == todo.carName);

    final nextDueMileage = curCar.mileage + repeat.mileageInterval;
    final int daysToDue =
        (repeat.mileageInterval / curCar.distanceRate).round();
    final DateTime nextDueDate =
        todo.completedDate.add(Duration(days: daysToDue));
    final Todo next = todo.copyWith(
        dueMileage: nextDueMileage, dueDate: nextDueDate, completed: false);
    repo.addNewTodo(next);
    return next;
  }

  Stream<TodosState> _mapCompleteTodoToState(CompleteTodo event) async* {
    final curTodo = event.todo;
    if (_repeatsBloc.state is RepeatsLoaded &&
        _carsBloc.state is CarsLoaded &&
        repo != null) {
      var updatedTodos = (state as TodosLoaded).todos;

      final RepeatsLoaded curRepeatsState = _repeatsBloc.state;
      final curRepeat = curRepeatsState.repeats
          .firstWhere((r) => r.name == curTodo.repeatName, orElse: () => null);
      if (!curRepeat.props.every((p) => p == null)) {
        final newTodo = _createNewTodoFromRepeat(curRepeat, curTodo);
        updatedTodos = updatedTodos..add(newTodo);
        await repo.addNewTodo(newTodo);
      }

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
        batch.updateData(updatedTodo.id, updatedTodo.toEntity().toDocument());
      });
      await batch.commit();
    }
  }

  double _calculateNextTodo(List<Todo> pastTodos, double mileageInterval) {
    pastTodos.sort((a, b) {
      if (a.dueMileage < b.dueMileage) {
        return 1;
      } else if (b.dueMileage < a.dueMileage) {
        return -1;
      }
      return 0;
    });
    final latest = pastTodos.toList().last;
    return latest.dueMileage + mileageInterval;
  }

  Stream<TodosState> _mapRepeatsRefreshToState(RepeatsRefresh event) async* {
    // TODO figure out what was/wasn't updated based on metadata?
    // new repeats, updated repeats, and deleted repeats affect this
    // TODO currently not removing todos with a deleted repeat
    final todos = (state is TodosLoaded) ? (state as TodosLoaded).todos : [];
    final batch = await repo.startTodoWriteBatch();
    for (var r in event.repeats) {
      if (todos.isNotEmpty &&
          todos.any((t) => !(t.completed ?? true) && t.repeatName == r.name)) {
        // redo the calculation for due date
        final Todo upcoming =
            todos.firstWhere((t) => !t.completed && t.repeatName == r.name);
        final updated = upcoming.copyWith(
            dueMileage: _calculateNextTodo(
                todos.where((t) => t.repeatName == r.name).toList(),
                r.mileageInterval));

        batch.updateData(updated.id, updated.toEntity().toDocument());
        // updatedTodos = updatedTodos
        //     .map((t) => (t.id == updated.id) ? updated : t)
        //     .toList();
      } else {
        // create a new todo for every car
        final cars = (_carsBloc.state as CarsLoaded).cars;
        final newTodos = cars
            // if the repeat does not have a list of cars because it is a default
            // then consider all cars to work
            .where((c) => r?.cars?.contains(c.name) ?? true)
            .map((c) {
          final pastRepeats = todos
              .where((t) => (t.repeatName == r.name) && (t.carName == c.name));
          if (pastRepeats.isEmpty) {
            // if the mileage interval is bigger than the car's current mileage,
            // then assume that it has not been done before.
            final dueMileage = (r.mileageInterval > c.mileage)
                ? r.mileageInterval
                : c.mileage + r.mileageInterval;
            return Todo(
                name: r.name,
                carName: c.name,
                repeatName: r.name,
                dueMileage: dueMileage,
                completed: false);
          } else {
            return Todo(
                name: r.name,
                carName: c.name,
                repeatName: r.name,
                dueMileage: _calculateNextTodo(pastRepeats, r.mileageInterval),
                completed: false);
          }
        });
        // newTodos.forEach((t) => repo.addNewTodo(t));
        newTodos.forEach((t) => batch.setData(t.toEntity().toDocument()));
        // updatedTodos.addAll(newTodos);
      }
    }
    await batch.commit();
    final updatedTodos = await repo.getCurrentTodos();
    print(updatedTodos);
    yield TodosLoaded(updatedTodos);
  }

  @override
  Future<void> close() {
    _dataSubscription?.cancel();
    _carsSubscription?.cancel();
    _repeatsSubscription?.cancel();
    _repoSubscription?.cancel();
    return super.close();
  }
}
