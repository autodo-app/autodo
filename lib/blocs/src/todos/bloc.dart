import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../../generated/localization.dart';
import '../../../models/models.dart';
import '../../../repositories/repositories.dart';
import '../../../units/units.dart';
import '../../../util.dart';
import '../../blocs.dart';
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

  @override
  void onTransition(dynamic transition) {
    print('*****************************************');
    print('**   onTransition $transition');
    print('*****************************************');
  }

  final DatabaseBloc _dbBloc;

  final CarsBloc _carsBloc;

  final NotificationsBloc _notificationsBloc;

  static final List<Todo> defaultsImperial = [
    Todo(
        name: IntlKeys.oil,
        mileageRepeatInterval: 3500 * Distance.miles,
        completed: false),
    Todo(
        name: IntlKeys.tireRotation,
        mileageRepeatInterval: 7500 * Distance.miles,
        completed: false),
    Todo(
        name: IntlKeys.engineFilter,
        mileageRepeatInterval: 45000 * Distance.miles,
        completed: false),
    Todo(
        name: IntlKeys.wiperBlades,
        mileageRepeatInterval: 30000 * Distance.miles,
        completed: false),
    Todo(
        name: IntlKeys.alignmentCheck,
        mileageRepeatInterval: 40000 * Distance.miles,
        completed: false),
    Todo(
        name: IntlKeys.cabinFilter,
        mileageRepeatInterval: 45000 * Distance.miles,
        completed: false),
    Todo(
        name: IntlKeys.tires,
        mileageRepeatInterval: 50000 * Distance.miles,
        completed: false),
    Todo(
        name: IntlKeys.brakes,
        mileageRepeatInterval: 60000 * Distance.miles,
        completed: false),
    Todo(
        name: IntlKeys.sparkPlugs,
        mileageRepeatInterval: 60000 * Distance.miles,
        completed: false),
    Todo(
        name: IntlKeys.frontStruts,
        mileageRepeatInterval: 75000 * Distance.miles,
        completed: false),
    Todo(
        name: IntlKeys.rearStruts,
        mileageRepeatInterval: 75000 * Distance.miles,
        completed: false),
    Todo(
        name: IntlKeys.battery,
        mileageRepeatInterval: 75000 * Distance.miles,
        completed: false),
    Todo(
        name: IntlKeys.serpentineBelt,
        mileageRepeatInterval: 150000 * Distance.miles,
        completed: false),
    Todo(
        name: IntlKeys.transmissionFluid,
        mileageRepeatInterval: 100000 * Distance.miles,
        completed: false),
    Todo(
        name: IntlKeys.coolantChange,
        mileageRepeatInterval: 100000 * Distance.miles,
        completed: false)
  ];
  static final List<Todo> defaultsMetric = [
    Todo(
        name: 'oil',
        mileageRepeatInterval: 6000 * Distance.kilometer,
        completed: false),
    Todo(
        name: 'tireRotation',
        mileageRepeatInterval: 12000 * Distance.kilometer,
        completed: false),
    Todo(
        name: 'engineFilter',
        mileageRepeatInterval: 75000 * Distance.kilometer,
        completed: false),
    Todo(
        name: 'wiperBlades',
        mileageRepeatInterval: 50000 * Distance.kilometer,
        completed: false),
    Todo(
        name: 'alignmentCheck',
        mileageRepeatInterval: 65000 * Distance.kilometer,
        completed: false),
    Todo(
        name: 'cabinFilter',
        mileageRepeatInterval: 75000 * Distance.kilometer,
        completed: false),
    Todo(
        name: 'tires',
        mileageRepeatInterval: 80000 * Distance.kilometer,
        completed: false),
    Todo(
        name: 'brakes',
        mileageRepeatInterval: 100000 * Distance.kilometer,
        completed: false),
    Todo(
        name: 'sparkPlugs',
        mileageRepeatInterval: 100000 * Distance.kilometer,
        completed: false),
    Todo(
        name: 'frontStruts',
        mileageRepeatInterval: 120000 * Distance.kilometer,
        completed: false),
    Todo(
        name: 'rearStruts',
        mileageRepeatInterval: 120000 * Distance.kilometer,
        completed: false),
    Todo(
        name: 'battery',
        mileageRepeatInterval: 120000 * Distance.kilometer,
        completed: false),
    Todo(
        name: 'serpentineBelt',
        mileageRepeatInterval: 250000 * Distance.kilometer,
        completed: false),
    Todo(
        name: 'transmissionFluid',
        mileageRepeatInterval: 150000 * Distance.kilometer,
        completed: false),
    Todo(
        name: 'coolantChange',
        mileageRepeatInterval: 150000 * Distance.kilometer,
        completed: false)
  ];

  StreamSubscription _dataSubscription, _carsSubscription, _repoSubscription;

  @override
  TodosState get initialState => TodosLoading();

  DataRepository get repo =>
      (_dbBloc.state is DbLoaded) ? (_dbBloc.state as DbLoaded).dataRepo : null;

  @override
  Stream<TodosState> mapEventToState(TodosEvent event) async* {
    print('*****************************************');
    print('**   NEW EVENT $event');
    print('*****************************************');
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
    } else if (event is TranslateDefaults) {
      yield* _mapTranslateDefaultsToState(event);
    } else if (event is AddMultipleTodos) {
      yield* _mapAddMultipleTodosToState(event);
    }
  }

  Stream<TodosState> _mapLoadTodosToState() async* {
    try {
      final todos = await repo
          .getCurrentTodos()
          .timeout(Duration(seconds: 2), onTimeout: () => []);
      if (todos != null) {
        yield TodosLoaded(todos: todos);
      } else {
        yield TodosLoaded(todos: []);
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

  static DateTime calcDueDate(Car car, double dueMileage) {
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
    final newDueDate = calcDueDate(car, todo.dueMileage);

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
    } else if ((state as TodosLoaded).defaults?.isEmpty ?? true) {
      print('Cannot update cars bloc without translating the default ToDos');
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
        (state as TodosLoaded).defaults.forEach((t) {
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
    yield (state as TodosLoaded).copyWith(todos: updatedTodos);
  }

  Stream<TodosState> _mapAddTodoToState(AddTodo event) async* {
    if (repo == null) {
      print('Error: adding todo to null repo');
      return;
    }
    final updatedTodos = List<Todo>.from((state as TodosLoaded).todos)
      ..add(event.todo);
    yield TodosLoaded(todos: updatedTodos);
    _scheduleNotification(event.todo);
    await repo.addNewTodo(event.todo);
  }

  Stream<TodosState> _mapAddMultipleTodosToState(
      AddMultipleTodos event) async* {
    if (repo == null) {
      print('Error: adding todo to null repo');
      return;
    }
    final updatedTodos = List<Todo>.from((state as TodosLoaded).todos)
      ..addAll(event.todos);
    yield TodosLoaded(todos: updatedTodos);
    event.todos.forEach(_scheduleNotification);
    final batch = await repo.startTodoWriteBatch();
    event.todos.forEach((t) {
      batch.setData(t.toDocument());
    });
    await batch.commit();
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
    yield TodosLoaded(todos: updatedTodos);
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
    var updatedTodos = List<Todo>.from((state as TodosLoaded).todos);

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
      // Creating a new one instead of .copyWith() so that null fields are
      // preserved
      final newTodo = Todo(
        name: curTodo.name,
        carName: curTodo.carName,
        dueMileage: newDueMileage,
        mileageRepeatInterval: curTodo.mileageRepeatInterval,
        estimatedDueDate: true,
        dueDate: TodosBloc.calcDueDate(car, newDueMileage),
        completed: false,
      );
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
    await batch.commit();

    updatedTodos = await repo.getCurrentTodos();
    yield (state as TodosLoaded).copyWith(todos: updatedTodos);
  }

  Stream<TodosState> _mapDeleteTodoToState(DeleteTodo event) async* {
    final updatedTodos = (state as TodosLoaded).todos.where((r) {
      if (r.id != null && event.todo.id != null) {
        return r.id != event.todo.id;
      } else {
        return r.name != event.todo.name;
      }
    }).toList();
    yield TodosLoaded(todos: updatedTodos);
    await repo.deleteTodo(event.todo);
  }

  Stream<TodosState> _mapToggleAllToState() async* {
    final currentState = state;
    if (currentState is TodosLoaded && repo != null) {
      final allComplete = currentState.todos.every((todo) => todo.completed);
      final updatedTodos = currentState.todos
          .map<Todo>((todo) => todo.copyWith(completed: !allComplete))
          .toList();
      yield TodosLoaded(todos: updatedTodos);
      final batch = await repo.startTodoWriteBatch();
      updatedTodos.forEach((updatedTodo) {
        batch.updateData(updatedTodo.id, updatedTodo.toDocument());
      });
      await batch.commit();
    }
  }

  Stream<TodosState> _mapTranslateDefaultsToState(
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
    if (state is TodosLoading) {
      yield TodosLoading(defaults: translated);
    } else if (state is TodosLoaded) {
      yield TodosLoaded(
          todos: (state as TodosLoaded).todos, defaults: translated);
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
