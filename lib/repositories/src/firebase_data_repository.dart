import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../generated/pubspec.dart';
import '../../models/models.dart';
import 'data_repository.dart';
import 'firebase_write_batch.dart';
import 'write_batch_wrapper.dart';

class FirebaseDataRepository extends DataRepository {
  FirebaseDataRepository._({Firestore firestoreInstance, @required String uuid})
      : assert(uuid != null),
        _firestoreInstance = firestoreInstance ?? Firestore.instance,
        _uuid = uuid;

  Future<void> _setDatabaseVersion(
      DocumentSnapshot userDoc, int newVersion) async {
    final out = userDoc.data ?? {};
    out['db_version'] = newVersion;
    await _userDoc.setData(userDoc.data);
  }

  Future<void> _upgrade(bool newUser) async {
    final dbVersion = Pubspec.db_version;
    final userDoc = await _userDoc.get();
    final data = userDoc?.data;
    final curVersion = data == null ? 1 : data['db_version'] ?? 1;

    if (newUser) {
      await _setDatabaseVersion(userDoc, dbVersion);
    } else if (curVersion != dbVersion) {
      final newVersion = await upgrade(curVersion, dbVersion);
      if (newVersion == dbVersion) {
        // upgrade worked successfully
        await _setDatabaseVersion(userDoc, newVersion);
      }
    }
  }

  /// Main constructor for the object.
  ///
  /// Set up this way to allow for asynchronous behavior in the ctor. Will
  /// check the user's current database version against the expected
  /// version and migrate the data if needed.
  static Future<FirebaseDataRepository> open(
      {Firestore firestoreInstance,
      @required String uuid,
      bool newUser}) async {
    final out = FirebaseDataRepository._(
        firestoreInstance: firestoreInstance, uuid: uuid);
    await out._upgrade(newUser ?? false);
    return out;
  }

  final Firestore _firestoreInstance;

  final String _uuid;

  DocumentReference get _userDoc =>
      _firestoreInstance.collection('users').document(_uuid);

  CollectionReference get _todos => _userDoc.collection('todos');

  CollectionReference get _refuelings => _userDoc.collection('refuelings');

  CollectionReference get _cars => _userDoc.collection('cars');

  @override
  Future<void> addNewTodo(Todo todo) {
    return _todos.add(todo.toDocument());
  }

  @override
  Future<void> deleteTodo(Todo todo) async {
    return _todos.document(todo.id).delete();
  }

  @override
  Stream<List<Todo>> todos() {
    return _todos.snapshots().map((snapshot) {
      return snapshot.documents.map((doc) => Todo.fromSnapshot(doc)).toList();
    });
  }

  @override
  Future<List<Todo>> getCurrentTodos() async {
    final snap = await _todos.getDocuments();
    return snap.documents.map((doc) => Todo.fromSnapshot(doc)).toList();
  }

  @override
  Future<void> updateTodo(Todo update) {
    return _todos.document(update.id).updateData(update.toDocument());
  }

  @override
  WriteBatchWrapper startTodoWriteBatch() {
    return FirebaseWriteBatch(
        firestoreInstance: _firestoreInstance, collection: _todos);
  }

  @override
  Future<void> addNewRefueling(Refueling refueling) {
    return _refuelings.add(refueling.toDocument());
  }

  @override
  Future<void> deleteRefueling(Refueling refueling) {
    return _refuelings.document(refueling.id).delete();
  }

  @override
  Stream<List<Refueling>> refuelings([bool forceRefresh]) {
    return _refuelings.snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => Refueling.fromMap(doc.documentID, doc.data))
          .toList();
    });
  }

  @override
  Future<List<Refueling>> getCurrentRefuelings() async {
    final snap = await _refuelings.getDocuments();
    return snap.documents
        .map((doc) => Refueling.fromMap(doc.documentID, doc.data))
        .toList();
  }

  @override
  Future<void> updateRefueling(Refueling refueling) {
    return _refuelings
        .document(refueling.id)
        .updateData(refueling.toDocument());
  }

  @override
  FutureOr<WriteBatchWrapper> startRefuelingWriteBatch() {
    return FirebaseWriteBatch(
        firestoreInstance: _firestoreInstance, collection: _refuelings);
  }

  @override
  Future<void> addNewCar(Car car) {
    return _cars.add(car.toDocument());
  }

  @override
  Future<void> deleteCar(Car car) {
    return _cars.document(car.id).delete();
  }

  @override
  Stream<List<Car>> cars() {
    return _cars.snapshots().map((snapshot) {
      return snapshot.documents.map((doc) => Car.fromSnapshot(doc)).toList();
    });
  }

  @override
  Future<List<Car>> getCurrentCars() async {
    final snap = await _cars.getDocuments();
    return snap.documents.map((doc) => Car.fromSnapshot(doc)).toList();
  }

  @override
  Future<void> updateCar(Car car) {
    return _cars.document(car.id).updateData(car.toDocument());
  }

  @override
  WriteBatchWrapper startCarWriteBatch() {
    return FirebaseWriteBatch(
        firestoreInstance: _firestoreInstance, collection: _cars);
  }

  @override
  Stream<int> notificationID() {
    return _userDoc
        .snapshots()
        .map((snap) => snap.data['lastNotificationId'] as int);
  }

  @override
  Future<bool> getPaidStatus() async {
    final snap = await _userDoc.get();
    return snap.data['paid'] as bool;
  }

  @override
  Future<List<Map<String, dynamic>>> getRepeats() async {
    final snap = await _userDoc.collection('repeats').getDocuments();
    return snap.documents.map((d) => d.data).toList();
  }

  @override
  List<Object> get props => [_firestoreInstance, _uuid];

  @override
  String toString() => 'FirebaseDataRepository { firestoreInstance: '
      '$_firestoreInstance, uuid: $_uuid, userDoc: $_userDoc, todos: '
      '$_todos, refuelings: $_refuelings, cars: $_cars }';
}
