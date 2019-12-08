import 'dart:async';

import 'package:autodo/blocs/cars/barrel.dart';
import 'package:autodo/localization.dart';
import 'package:flutter/foundation.dart';
import 'package:bloc/bloc.dart';
import 'event.dart';
import 'state.dart';
import 'package:autodo/repositories/barrel.dart';
import 'package:autodo/models/barrel.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  final DataRepository _dataRepository;
  StreamSubscription _dataSubscription, _carsSubscription;
  final CarsBloc _carsBloc;
  final NotificationsBloc _notificationsBloc;

  List<Car> _carsCache;

  TodosBloc({
    @required DataRepository dataRepository, 
    @required CarsBloc carsBloc,
    @required NotificationsBloc notificationsBloc
  }) : assert(dataRepository != null), assert(carsBloc != null),
       assert(notificationsBloc != null), _dataRepository = dataRepository, 
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
    } else if (event is ClearCompleted) {
      yield* _mapClearCompletedToState();
    } else if (event is TodosUpdated) {
      yield* _mapTodosUpdateToState(event);
    } else if (event is UpdateDueDates) {
      yield* _mapUpdateDueDatesToState(event);
    }
  }

  Stream<TodosState> _mapLoadTodosToState() async* {
    _dataSubscription?.cancel();
    _dataSubscription = _dataRepository.todos().listen(
          (todos) => add(TodosUpdated(todos)),
        );
    _carsSubscription = _carsBloc.listen( 
      (state) {
        if (state is CarsLoaded) {
          add(UpdateDueDates(state.cars));
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

  Stream<TodosState> _mapUpdateDueDatesToState(UpdateDueDates event) async* {
    List<Car> cars = event.cars;
    if (state is TodosLoaded) {
      TodosLoaded curState = state;
      WriteBatchWrapper batch = _dataRepository.startTodoWriteBatch();
      for (var car in cars) {
        if (_carsCache?.contains(car) ?? false) continue;

        List<Todo> thisCarsTodos = curState.todos.where((t) => t.carName == car.name);
        for (var todo in thisCarsTodos) {
          if (todo.estimatedDueDate == null ||
              !todo.estimatedDueDate) {
            continue;
          } 
          var distanceToTodo = todo.dueMileage - car.mileage;
          int daysToTodo = (distanceToTodo / car.distanceRate).round();
          Duration timeToTodo = Duration(days: daysToTodo);
          var newDueDate = car.lastMileageUpdate.add(timeToTodo);
          _notificationsBloc.rescheduleNotification(todo);
          Todo out = todo.copyWith(dueDate: newDueDate);
          batch.updateData(todo.id, todo.toEntity().toDocument());
        }
      }
      _carsCache = cars;
      batch.commit();
    }
  }

  Stream<TodosState> _mapAddTodoToState(AddTodo event) async* {
    _scheduleNotification(event.todo);
    // out = event.todo.copyWith(notificationID: notificationID);
    _dataRepository.addNewTodo(event.todo);
  }

  Stream<TodosState> _mapUpdateTodoToState(UpdateTodo event) async* {
    _dataRepository.updateTodo(event.updatedTodo);
  }

  Stream<TodosState> _mapDeleteTodoToState(DeleteTodo event) async* {
    _dataRepository.deleteTodo(event.todo);
  }

  Stream<TodosState> _mapToggleAllToState() async* {
    final currentState = state;
    if (currentState is TodosLoaded) {
      final allComplete = currentState.todos.every((todo) => todo.completed);
      final List<Todo> updatedTodos = currentState.todos
          .map((todo) => todo.copyWith(completed: !allComplete))
          .toList();
      updatedTodos.forEach((updatedTodo) {
        _dataRepository.updateTodo(updatedTodo);
      });
    }
  }

  Stream<TodosState> _mapClearCompletedToState() async* {
    final currentState = state;
    if (currentState is TodosLoaded) {
      final List<Todo> completedTodos =
          currentState.todos.where((todo) => todo.completed).toList();
      completedTodos.forEach((completedTodo) {
        _dataRepository.deleteTodo(completedTodo);
      });
    }
  }

  Stream<TodosState> _mapTodosUpdateToState(TodosUpdated event) async* {
    yield TodosLoaded(event.todos);
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
    _dataSubscription?.cancel();
    return super.close();
  }
}
