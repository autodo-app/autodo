import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:bloc/bloc.dart';
import 'event.dart';
import 'state.dart';
import 'package:autodo/repositories/barrel.dart';
import 'package:autodo/models/barrel.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  final DataRepository _todosRepository;
  StreamSubscription _todosSubscription;

  TodosBloc({@required DataRepository todosRepository})
      : assert(todosRepository != null),
        _todosRepository = todosRepository;

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
    }
  }

  Stream<TodosState> _mapLoadTodosToState() async* {
    _todosSubscription?.cancel();
    _todosSubscription = _todosRepository.todos().listen(
          (todos) => add(TodosUpdated(todos)),
        );
  }

  Future<int> _scheduleNotification(Todo todo) async {
    if (item.dueDate != null) {
      var id = await NotificationBLoC().scheduleNotification(
          datetime: item.dueDate,
          title: 'Maintenance ToDo Due Soon: ${item.name}',
          body: '');
      return id;
    }
  }

  Future<void> updateDueDates(Car car) async {
    WriteBatch batch = Firestore.instance.batch();
    QuerySnapshot snap = await FirestoreBLoC()
        .getUserDocument()
        .collection('todos')
        .getDocuments();
    for (var todo in snap.documents) {
      if (!todo.data['tags'].contains(car.name) ||
          todo.data['estimatedDueDate'] == null ||
          !todo.data['estimatedDueDate']) continue;
      MaintenanceTodoItem item = MaintenanceTodoItem.fromMap(todo.data);

      var distanceToTodo = todo.data['dueMileage'] - car.mileage;
      int daysToTodo = (distanceToTodo / car.distanceRate).round();
      Duration timeToTodo = Duration(days: daysToTodo);
      item.dueDate = car.lastMileageUpdate.add(timeToTodo);
      print('${car.distanceRate} + ${item.dueDate}');
      scheduleNotification(item);
      var ref = FirestoreBLoC()
          .getUserDocument()
          .collection('todos')
          .document(todo.documentID);
      batch.updateData(ref, item.toJSON());
    }
    await batch.commit();
  }

  Stream<TodosState> _mapAddTodoToState(AddTodo event) async* {
    Todo out;
    var notificationID = await _scheduleNotification(event.todo);
    out = event.todo.copyWith(notificationID: notificationID);
    _todosRepository.addNewTodo(out);
  }

  Stream<TodosState> _mapUpdateTodoToState(UpdateTodo event) async* {
    _todosRepository.updateTodo(event.updatedTodo);
  }

  Stream<TodosState> _mapDeleteTodoToState(DeleteTodo event) async* {
    _todosRepository.deleteTodo(event.todo);
  }

  Stream<TodosState> _mapToggleAllToState() async* {
    final currentState = state;
    if (currentState is TodosLoaded) {
      final allComplete = currentState.todos.every((todo) => todo.complete);
      final List<Todo> updatedTodos = currentState.todos
          .map((todo) => todo.copyWith(complete: !allComplete))
          .toList();
      updatedTodos.forEach((updatedTodo) {
        _todosRepository.updateTodo(updatedTodo);
      });
    }
  }

  Stream<TodosState> _mapClearCompletedToState() async* {
    final currentState = state;
    if (currentState is TodosLoaded) {
      final List<Todo> completedTodos =
          currentState.todos.where((todo) => todo.complete).toList();
      completedTodos.forEach((completedTodo) {
        _todosRepository.deleteTodo(completedTodo);
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
    _todosSubscription?.cancel();
    return super.close();
  }
}
