import 'dart:async';

import 'package:autodo/repositories/write_batch_wrappers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'data_repository.dart';
import 'package:autodo/models/barrel.dart';
import 'package:autodo/entities/barrel.dart';

class FirebaseDataRepository implements DataRepository {
  final todoCollection = Firestore.instance.collection('todos');
  final refuelingCollection = Firestore.instance.collection('refuelings');
  final carCollection = Firestore.instance.collection('cars');
  final repeatCollection = Firestore.instance.collection('repeats');

  @override
  Future<void> addNewTodo(Todo todo) {
    return todoCollection.add(todo.toEntity().toDocument());
  }

  @override
  Future<void> deleteTodo(Todo todo) async {
    return todoCollection.document(todo.id).delete();
  }

  @override
  Stream<List<Todo>> todos() {
    return todoCollection.snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => Todo.fromEntity(TodoEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  @override
  Future<void> updateTodo(Todo update) {
    return todoCollection
        .document(update.id)
        .updateData(update.toEntity().toDocument());
  }

  @override
  WriteBatchWrapper startTodoWriteBatch() {
    return WriteBatchWrapper(todoCollection);
  }

  @override
  Future<void> addNewRefueling(Refueling refueling) {
    return refuelingCollection.add(refueling.toEntity().toDocument());
  }

  @override
  Future<void> deleteRefueling(Refueling refueling) {
    return refuelingCollection.document(refueling.id).delete();
  }

  @override
  Stream<List<Refueling>> refuelings() {
    return refuelingCollection.snapshots().map((snapshot) {
      return snapshot.documents
        .map((doc) => Refueling.fromEntity(RefuelingEntity.fromSnapshot(doc)))
        .toList();
    });
  }

  @override
  Future<void> updateRefueling(Refueling refueling) {
    return refuelingCollection
      .document(refueling.id)
      .updateData(refueling.toEntity().toDocument());
  }

  @override
  WriteBatchWrapper startRefuelingWriteBatch() {
    return WriteBatchWrapper(refuelingCollection);
  }

  @override
  Future<void> addNewCar(Car car) {
    return carCollection.add(car.toEntity().toDocument());
  }

  @override
  Future<void> deleteCar(Car car) {
    return carCollection.document(car.id).delete();
  }

  @override
  Stream<List<Car>> cars() {
    return carCollection.snapshots().map((snapshot) {
      return snapshot.documents
        .map((doc) => Car.fromEntity(CarEntity.fromSnapshot(doc)))
        .toList();
    });
  }

  @override
  Future<void> updateCar(Car car) {
    return carCollection
      .document(car.id)
      .updateData(car.toEntity().toDocument());
  }

  @override
  WriteBatchWrapper startCarWriteBatch() {
    return WriteBatchWrapper(carCollection);
  }

  @override
  Future<void> addNewRepeat(Repeat repeat) {
    return repeatCollection.add(repeat.toEntity().toDocument());
  }

  @override
  Future<void> deleteRepeat(Repeat repeat) {
    return repeatCollection.document(repeat.id).delete();
  }

  @override
  Stream<List<Repeat>> repeats() {
    return repeatCollection.snapshots().map((snapshot) {
      return snapshot.documents
        .map((doc) => Repeat.fromEntity(RepeatEntity.fromSnapshot(doc)))
        .toList();
    });
  }

  @override
  Future<void> updateRepeat(Repeat repeat) {
    return repeatCollection
      .document(repeat.id)
      .updateData(repeat.toEntity().toDocument());
  }

  @override
  WriteBatchWrapper startRepeatWriteBatch() {
    return WriteBatchWrapper(repeatCollection);
  }
}