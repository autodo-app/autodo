import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

import 'data_repository.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/entities/entities.dart';
import 'write_batch_wrappers.dart';

class FirebaseDataRepository extends Equatable implements DataRepository {
  final Firestore _firestoreInstance;
  final String _uuid;

  DocumentReference get _userDoc =>
      _firestoreInstance.collection('users').document(_uuid);
  CollectionReference get _todos => _userDoc.collection('todos');
  CollectionReference get _refuelings => _userDoc.collection('refuelings');
  CollectionReference get _cars => _userDoc.collection('cars');
  CollectionReference get _repeats => _userDoc.collection('repeats');

  FirebaseDataRepository({Firestore firestoreInstance, @required String uuid})
      : assert(uuid != null),
        _firestoreInstance = firestoreInstance ?? Firestore.instance,
        _uuid = uuid;

  @override
  Future<void> addNewTodo(Todo todo) {
    return _todos.add(todo.toEntity().toDocument());
  }

  @override
  Future<void> deleteTodo(Todo todo) async {
    return _todos.document(todo.id).delete();
  }

  @override
  Stream<List<Todo>> todos() {
    return _todos.snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => Todo.fromEntity(TodoEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  @override
  Future<void> updateTodo(Todo update) {
    return _todos
        .document(update.id)
        .updateData(update.toEntity().toDocument());
  }

  @override
  WriteBatchWrapper startTodoWriteBatch() {
    return WriteBatchWrapper(
        firestoreInstance: _firestoreInstance, collection: _todos);
  }

  @override
  Future<void> addNewRefueling(Refueling refueling) {
    return _refuelings.add(refueling.toEntity().toDocument());
  }

  @override
  Future<void> deleteRefueling(Refueling refueling) {
    return _refuelings.document(refueling.id).delete();
  }

  @override
  Stream<List<Refueling>> refuelings() {
    return _refuelings.snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => Refueling.fromEntity(RefuelingEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  @override
  Future<void> updateRefueling(Refueling refueling) {
    return _refuelings
        .document(refueling.id)
        .updateData(refueling.toEntity().toDocument());
  }

  @override
  WriteBatchWrapper startRefuelingWriteBatch() {
    return WriteBatchWrapper(
        firestoreInstance: _firestoreInstance, collection: _refuelings);
  }

  @override
  Future<void> addNewCar(Car car) {
    return _cars.add(car.toEntity().toDocument());
  }

  @override
  Future<void> deleteCar(Car car) {
    return _cars.document(car.id).delete();
  }

  @override
  Stream<List<Car>> cars() {
    return _cars.snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => Car.fromEntity(CarEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  @override
  Future<void> updateCar(Car car) {
    return _cars.document(car.id).updateData(car.toEntity().toDocument());
  }

  @override
  WriteBatchWrapper startCarWriteBatch() {
    return WriteBatchWrapper(
        firestoreInstance: _firestoreInstance, collection: _cars);
  }

  @override
  Future<List<Repeat>> addNewRepeat(Repeat repeat) async {
    await _repeats.add(repeat.toEntity().toDocument());
    var updatedDocs = await _repeats.getDocuments();
    return updatedDocs.documents
      .map((doc) => Repeat.fromEntity(RepeatEntity.fromSnapshot(doc)))
      .toList();
  }

  @override
  Future<void> deleteRepeat(Repeat repeat) {
    return _repeats.document(repeat.id).delete();
  }

  @override
  Stream<List<Repeat>> repeats() {
    return _repeats.snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => Repeat.fromEntity(RepeatEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  @override
  Future<void> updateRepeat(Repeat repeat) {
    return _repeats
        .document(repeat.id)
        .updateData(repeat.toEntity().toDocument());
  }

  @override
  WriteBatchWrapper startRepeatWriteBatch() {
    return WriteBatchWrapper(
        firestoreInstance: _firestoreInstance, collection: _repeats);
  }

  @override
  Stream<int> notificationID() {
    return _userDoc
        .snapshots()
        .map((snap) => snap.data['lastNotificationId'] as int);
  }

  @override
  List<Object> get props => [_firestoreInstance, _uuid];

  @override
  toString() => "FirebaseDataRepository { firestoreInstance: "
      "$_firestoreInstance, uuid: $_uuid, userDoc: $_userDoc, todos: "
      "$_todos, refuelings: $_refuelings, cars: $_cars, repeats: $_repeats }";
}
