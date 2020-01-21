import 'dart:async';

import 'package:equatable/equatable.dart';

import 'package:autodo/models/models.dart';
import 'write_batch_wrapper.dart';

abstract class DataRepository extends Equatable {
  // Todos
  Future<void> addNewTodo(Todo todo);

  Future<void> deleteTodo(Todo todo);

  Stream<List<Todo>> todos();

  Future<List<Todo>> getCurrentTodos();

  Future<void> updateTodo(Todo todo);

  FutureOr<WriteBatchWrapper> startTodoWriteBatch();

  // Refuelings
  Future<void> addNewRefueling(Refueling refueling);

  Future<void> deleteRefueling(Refueling refueling);

  Stream<List<Refueling>> refuelings([bool forceRefresh]);

  Future<List<Refueling>> getCurrentRefuelings();

  Future<void> updateRefueling(Refueling refueling);

  FutureOr<WriteBatchWrapper> startRefuelingWriteBatch();

  // Cars
  Future<void> addNewCar(Car car);

  Future<void> deleteCar(Car car);

  Stream<List<Car>> cars();

  Future<List<Car>> getCurrentCars();

  Future<void> updateCar(Car car);

  FutureOr<WriteBatchWrapper> startCarWriteBatch();

  // Repeats
  Future<List<Repeat>> addNewRepeat(Repeat repeat);

  Future<void> deleteRepeat(Repeat repeat);

  Stream<List<Repeat>> repeats();

  Future<List<Repeat>> getCurrentRepeats();

  Future<void> updateRepeat(Repeat repeat);

  FutureOr<WriteBatchWrapper> startRepeatWriteBatch();

  // Notifications
  Stream<int> notificationID();

  // Paid or Ad-supported version
  Future<bool> getPaidStatus();
}
