import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import '../../../generated/localization.dart';
import '../../../models/models.dart';
import '../../../repositories/repositories.dart';
import '../../../util.dart';
import '../cars/barrel.dart';
import '../database/barrel.dart';
import '../notifications/barrel.dart';
import 'event.dart';
import 'state.dart';

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
        add(CarsUpdated(state.cars));
      }
    });
  }

  final DatabaseBloc _dbBloc;

  final CarsBloc _carsBloc;

  final NotificationsBloc _notificationsBloc;

  static final List<Todo> defaults = [
    // TODO: Translate this
    Todo(name: 'oil', mileageRepeatInterval: 3500, completed: false),
    Todo(name: 'tireRotation', mileageRepeatInterval: 7500, completed: false),
    Todo(name: 'engineFilter', mileageRepeatInterval: 45000, completed: false),
    Todo(name: 'wiperBlades', mileageRepeatInterval: 30000, completed: false),
    Todo(
        name: 'alignmentCheck', mileageRepeatInterval: 40000, completed: false),
    Todo(name: 'cabinFilter', mileageRepeatInterval: 45000, completed: false),
    Todo(name: 'tires', mileageRepeatInterval: 50000, completed: false),
    Todo(name: 'brakes', mileageRepeatInterval: 60000, completed: false),
    Todo(name: 'sparkPlugs', mileageRepeatInterval: 60000, completed: false),
    Todo(name: 'frontStruts', mileageRepeatInterval: 75000, completed: false),
    Todo(name: 'rearStruts', mileageRepeatInterval: 75000, completed: false),
    Todo(name: 'battery', mileageRepeatInterval: 75000, completed: false),
    Todo(
        name: 'serpentineBelt',
        mileageRepeatInterval: 150000,
        completed: false),
    Todo(
        name: 'transmissionFluid',
        mileageRepeatInterval: 100000,
        completed: false),
    Todo(name: 'coolantChange', mileageRepeatInterval: 100000, completed: false)
  ];

  StreamSubscription _dataSubscription, _carsSubscription, _repoSubscription;

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
    } else if (event is CompleteTodo) {
      yield* _mapCompleteTodoToState(event);
    } else if (event is CarsUpdated) {
      yield* _mapCarsUpdatedToState(event);
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

  DateTime _calcDueDate(Car car, double dueMileage) {
    if (car.distanceRate == 0 || car.distanceRate == null) {
      return null;
    }

    final distanceToTodo = dueMileage - car.mileage;
    var daysToTodo = 0; // ToDo: Needs proper fix
    try {
      daysToTodo = (distanceToTodo / car.distanceRate).round();
    } catch (e) {
      print(e);
    }
    final timeToTodo = Duration(days: daysToTodo);
    return roundToDay(car.lastMileageUpdate.toUtc()).add(timeToTodo).toLocal();
  }

  Todo _updateDueDate(car, todo, batch) {
    final newDueDate = _calcDueDate(car, todo.dueMileage);

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
      (t.estimatedDueDate ?? true) &&
      !(t.completed ?? false);

  Stream<TodosState> _mapCarsUpdatedToState(CarsUpdated event) async* {
    if (repo == null) {
      print('Error: trying to update todos for cars update but repo is null');
      return;
    } else if (!(state is TodosLoaded)) {
      print(
          'Cannot update in response to cars loaded when state is not TodosLoaded');
      return;
    }
    final cars = event.cars;
    final curTodos = (state as TodosLoaded).todos;
    final batch = await repo.startTodoWriteBatch();

    // Add default todos to any new cars
    final newCars = cars
        .map((c) => curTodos.any((r) => r.carName == c.name) ? null : c)
        .toList();
    newCars.removeWhere((c) => c == null);
    if (newCars.isNotEmpty) {
      newCars.forEach((c) {
        defaults.forEach((t) {
          final dueMileage = (t.mileageRepeatInterval < c.mileage)
              ? (c.mileage + t.mileageRepeatInterval)
              : t.mileageRepeatInterval;
          final newTodo = t.copyWith(carName: c.name, dueMileage: dueMileage);
          batch.setData(newTodo.toDocument());
        });
      });
    }

    // Update the dueDate based on the car's distance rate
    cars.forEach((car) {
      // only using existing todos here because the defaults don't have ID values
      // yet. Additionally, any default todos that are added will be given to a
      // new car that will not yet have a distanceRate established
      curTodos.forEach((t) {
        if (_shouldUpdate(car, t)) {
          _updateDueDate(car, t, batch);
        }
      });
    });

    // need to wait on this, otherwise the "currentTodos" call will return the
    // old state
    await batch.commit();
    final updatedTodos = await repo.getCurrentTodos();
    yield TodosLoaded(updatedTodos);
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
    if (!(_carsBloc.state is CarsLoaded) || repo == null) {
      print('Bad state for todo completion, repo and carsbloc are not ready');
      return;
    }
    final curTodo = event.todo;
    final car = (_carsBloc.state as CarsLoaded)
        .cars
        .firstWhere((c) => c.name == curTodo.carName);
    var updatedTodos = (state as TodosLoaded).todos;

    final batch = await repo.startTodoWriteBatch();
    final completedTodo = curTodo.copyWith(
        completed: true,
        completedDate: event.completedDate ?? DateTime.now(),
        completedMileage:
            car.mileage // TODO: make this a user-configurable value?
        );
    batch.updateData(completedTodo.id, completedTodo.toDocument());
    updatedTodos = updatedTodos
        .map((t) => (t.id == completedTodo.id) ? completedTodo : t)
        .toList();

    // Add a new todo if applicable
    if (completedTodo.mileageRepeatInterval != null) {
      final newDueMileage = curTodo.mileageRepeatInterval + car.mileage;
      final newTodo = curTodo.copyWith(
          dueMileage: newDueMileage,
          dueDate: _calcDueDate(car, newDueMileage),
          estimatedDueDate: true);
      batch.setData(newTodo.toDocument());
      updatedTodos.add(newTodo);
    } else if (completedTodo.dateRepeatInterval != null) {
      final newTodo = curTodo.copyWith(
        dueDate: roundToDay(
            curTodo.dateRepeatInterval.addToDate(curTodo.completedDate)),
      );
      batch.setData(newTodo.toDocument());
      updatedTodos.add(newTodo);
    }
    // TODO: this yield is important for verifying this output in unit tests
    // but could cause a brief period of time where an edit button is presed
    // on a ToDo that does not yet have an ID value.
    yield TodosLoaded(updatedTodos);
    await batch.commit();

    updatedTodos = await repo.getCurrentTodos();
    yield TodosLoaded(updatedTodos);
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

  @override
  Future<void> close() {
    _dataSubscription?.cancel();
    _carsSubscription?.cancel();
    _repoSubscription?.cancel();
    return super.close();
  }
}
