import 'dart:async';

import 'package:autodo/blocs/cars/barrel.dart';
import 'package:autodo/blocs/repeating/barrel.dart';
import 'package:autodo/blocs/notifications/barrel.dart';
import 'package:autodo/localization.dart';
import 'package:flutter/foundation.dart';
import 'package:bloc/bloc.dart';
import 'event.dart';
import 'state.dart';
import 'package:autodo/repositories/barrel.dart';
import 'package:autodo/models/barrel.dart';
import 'package:autodo/util.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  final DataRepository _dataRepository;
  final CarsBloc _carsBloc;
  final NotificationsBloc _notificationsBloc;
  final RepeatsBloc _repeatsBloc;
  StreamSubscription _dataSubscription, _carsSubscription, _repeatsSubscription;
  
  List<Car> _carsCache;

  TodosBloc({
    @required DataRepository dataRepository, 
    @required CarsBloc carsBloc,
    @required NotificationsBloc notificationsBloc,
    @required RepeatsBloc repeatsBloc
  }) : assert(dataRepository != null), assert(carsBloc != null),
       assert(notificationsBloc != null), assert(repeatsBloc != null),
       _dataRepository = dataRepository, _repeatsBloc = repeatsBloc, 
       _carsBloc = carsBloc, _notificationsBloc = notificationsBloc;

  @override
  TodosState get initialState => TodosLoading();

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
      final todos = await _dataRepository.todos().first;
      if (todos != null) {
        yield TodosLoaded(todos);
      } else {
        yield TodosNotLoaded();
      }
    } catch (_) {
      yield TodosNotLoaded();
    }
    _dataSubscription?.cancel();
    // _dataSubscription = _dataRepository.todos().listen(
    //       (todos) => add(TodosUpdated(todos)),
    //     );
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
    (t.carName == car.name && (t?.estimatedDueDate ?? false));

  Stream<TodosState> _mapUpdateDueDatesToState(UpdateDueDates event) async* {
    List<Car> cars = event.cars;
    if (state is TodosLoaded) {
      TodosLoaded curState = state;
      WriteBatchWrapper batch = _dataRepository.startTodoWriteBatch();
      List<Todo> updatedTodos;
      for (var car in cars) {
        if (_carsCache?.contains(car) ?? false) continue;

        updatedTodos = curState.todos
          .map((t) => _shouldUpdate(car, t) ? _updateDueDate(car, t, batch) : t)
          .toList();
      }
      yield TodosLoaded(updatedTodos);
      _carsCache = cars;
      batch.commit();
    }
  }

  Stream<TodosState> _mapAddTodoToState(AddTodo event) async* {
    final List<Todo> updatedTodos = List.from((state as TodosLoaded).todos)..add(event.todo);
    yield TodosLoaded(updatedTodos);
    _scheduleNotification(event.todo);
    // out = event.todo.copyWith(notificationID: notificationID);
    _dataRepository.addNewTodo(event.todo);
  }

  Stream<TodosState> _mapUpdateTodoToState(UpdateTodo event) async* {
    final List<Todo> updatedTodos = (state as TodosLoaded)
      .todos.map((r) => r.id == event.updatedTodo.id ? event.updatedTodo : r)
      .toList();
    yield TodosLoaded(updatedTodos);
    _dataRepository.updateTodo(event.updatedTodo);
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
    _dataRepository.addNewTodo(next);
    return next;
  }

  Stream<TodosState> _mapCompleteTodoToState(CompleteTodo event) async* {
    Todo curTodo = event.todo;
    if (_repeatsBloc.state is RepeatsLoaded && 
        _carsBloc.state is CarsLoaded) {
      List<Todo> updatedTodos = (state as TodosLoaded).todos;

      RepeatsLoaded curRepeatsState = _repeatsBloc.state;
      Repeat curRepeat = curRepeatsState.repeats.firstWhere((r) => r.name == curTodo.repeatName, orElse: () => null);
      // throw Exception();
      if (!curRepeat.props.every((p) => p == null)) {
        Todo newTodo = _createNewTodoFromRepeat(curRepeat, curTodo);
        updatedTodos = updatedTodos..add(newTodo);
        _dataRepository.addNewTodo(newTodo);
      }
      
      Todo completedTodo = curTodo.copyWith(
        completed: true, 
        completedDate: event.completedDate ?? DateTime.now(),
      );
      updatedTodos = updatedTodos
        .map((t) => (t.id == completedTodo.id) ? completedTodo : t)
        .toList();
      yield TodosLoaded(updatedTodos);
      _dataRepository.updateTodo(completedTodo);
    }
  }

  Stream<TodosState> _mapDeleteTodoToState(DeleteTodo event) async* {
    final updatedTodos = (state as TodosLoaded)
          .todos
          .where((r) => r.id != event.todo.id)
          .toList();
    yield TodosLoaded(updatedTodos);
    _dataRepository.deleteTodo(event.todo);
  }

  Stream<TodosState> _mapToggleAllToState() async* {
    final currentState = state;
    if (currentState is TodosLoaded) {
      final allComplete = currentState.todos.every((todo) => todo.completed);
      final List<Todo> updatedTodos = currentState.todos
          .map((todo) => todo.copyWith(completed: !allComplete))
          .toList();
      yield TodosLoaded(updatedTodos);
      updatedTodos.forEach((updatedTodo) {
        _dataRepository.updateTodo(updatedTodo);
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
