import 'dart:async';

import 'package:autodo/models/barrel.dart';

abstract class DataRepository {
  // Todos
  Future<void> addNewTodo(Todo todo);

  Future<void> deleteTodo(Todo todo);

  Stream<List<Todo>> todos();

  Future<void> updateTodo(Todo todo);

  // Refuelings
  Future<void> addNewRefueling(Refueling refueling);

  Future<void> deleteRefueling(Refueling refueling);

  Stream<List<Refueling>> refuelings();

  Future<void> updateRefueling(Refueling refueling);

  // Cars
  Future<void> addNewCar(Car car);

  Future<void> deleteCar(Car car);

  Stream<List<Car>> cars();

  Future<void> updateCar(Car car);

  // Repeats
  Future<void> addNewRepeat(Repeat repeat);

  Future<void> deleteRepeat(Repeat repeat);

  Stream<List<Repeat>> repeats();

  Future<void> updateRepeat(Repeat repeat);
}