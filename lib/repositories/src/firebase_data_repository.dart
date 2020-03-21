import 'dart:async';

import 'package:flutter/services.dart';
import 'package:autodo/repositories/repositories.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:yaml/yaml.dart';

import 'package:autodo/units/units.dart';
import 'data_repository.dart';
import 'package:autodo/models/models.dart';
import 'package:autodo/entities/entities.dart';
import 'write_batch_wrapper.dart';
import 'firebase_write_batch.dart';

class FirebaseDataRepository extends Equatable implements DataRepository {
  FirebaseDataRepository._({Firestore firestoreInstance, @required String uuid})
      : assert(uuid != null),
        _firestoreInstance = firestoreInstance ?? Firestore.instance,
        _uuid = uuid;

  Future<void> _upgrade() async {
    final text = await rootBundle.loadString('pubspec.yaml');
    final pubspec = loadYaml(text);
    final dbVersion = pubspec['db_version'];
    final userDoc = await _userDoc.get();
    final curVersion = userDoc.data['db_version'] ?? 0;
    if (curVersion != dbVersion) {
      await upgrade(curVersion, dbVersion);
    }
  }

  /// Main constructor for the object.
  ///
  /// Set up this way to allow for asynchronous behavior in the ctor. Will
  /// check the user's current database version against the expected
  /// version and migrate the data if needed.
  static Future<FirebaseDataRepository> open({Firestore firestoreInstance, @required String uuid}) async {
    final out = FirebaseDataRepository._(firestoreInstance: firestoreInstance, uuid: uuid);
    await out._upgrade();
    return out;
  }

  final Firestore _firestoreInstance;

  final String _uuid;

  DocumentReference get _userDoc =>
      _firestoreInstance.collection('users').document(_uuid);

  CollectionReference get _todos => _userDoc.collection('todos');

  CollectionReference get _refuelings => _userDoc.collection('refuelings');

  CollectionReference get _cars => _userDoc.collection('cars');

  CollectionReference get _repeats => _userDoc.collection('repeats');

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
  Future<List<Todo>> getCurrentTodos() async {
    final snap = await _todos.getDocuments();
    return snap.documents
        .map((doc) => Todo.fromEntity(TodoEntity.fromSnapshot(doc)))
        .toList();
  }

  @override
  Future<void> updateTodo(Todo update) {
    return _todos
        .document(update.id)
        .updateData(update.toEntity().toDocument());
  }

  @override
  WriteBatchWrapper startTodoWriteBatch() {
    return FirebaseWriteBatch(
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
  Stream<List<Refueling>> refuelings([bool forceRefresh]) {
    return _refuelings.snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => Refueling.fromEntity(RefuelingEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  @override
  Future<List<Refueling>> getCurrentRefuelings() async {
    final snap = await _refuelings.getDocuments();
    return snap.documents
        .map((doc) => Refueling.fromEntity(RefuelingEntity.fromSnapshot(doc)))
        .toList();
  }

  @override
  Future<void> updateRefueling(Refueling refueling) {
    return _refuelings
        .document(refueling.id)
        .updateData(refueling.toEntity().toDocument());
  }

  @override
  FutureOr<WriteBatchWrapper> startRefuelingWriteBatch() {
    return FirebaseWriteBatch(
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
  Future<List<Car>> getCurrentCars() async {
    final snap = await _cars.getDocuments();
    return snap.documents
        .map((doc) => Car.fromEntity(CarEntity.fromSnapshot(doc)))
        .toList();
  }

  @override
  Future<void> updateCar(Car car) {
    return _cars.document(car.id).updateData(car.toEntity().toDocument());
  }

  @override
  WriteBatchWrapper startCarWriteBatch() {
    return FirebaseWriteBatch(
        firestoreInstance: _firestoreInstance, collection: _cars);
  }

  @override
  Future<void> addNewRepeat(Repeat repeat) async {
    await _repeats.add(repeat.toEntity().toDocument());
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
  Future<List<Repeat>> getCurrentRepeats() async {
    final snap = await _repeats.getDocuments();
    return snap.documents
        .map((doc) => Repeat.fromEntity(RepeatEntity.fromSnapshot(doc)))
        .toList();
  }

  @override
  Future<void> updateRepeat(Repeat repeat) {
    return _repeats
        .document(repeat.id)
        .updateData(repeat.toEntity().toDocument());
  }

  @override
  WriteBatchWrapper startRepeatWriteBatch() {
    return FirebaseWriteBatch(
        firestoreInstance: _firestoreInstance, collection: _repeats);
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
  Future<void> upgrade(int curVer, int desVer) async {
    if (curVer == 1 && desVer == 2) {
      // Move to SI units internally
      final todos = await getCurrentTodos();
      final todoWriteBatch = startTodoWriteBatch();
      todos.map((t) {
        final dueMileage = Distance(DistanceUnit.imperial, Locale('en-us')).unitToInternal(t.dueMileage);
        return t.copyWith(dueMileage: dueMileage);
      }).forEach((t) {
        todoWriteBatch.updateData(t.id, t.toEntity().toDocument());
      });
      await todoWriteBatch.commit();

      final refuelings = await getCurrentRefuelings();
      final refuelingWriteBatch = await startRefuelingWriteBatch();
      refuelings.map((r) {
        final mileage = Distance(DistanceUnit.imperial, Locale('en-us')).unitToInternal(r.mileage);
        final amount = Volume(VolumeUnit.imperial, Locale('en-us')).unitToInternal(r.amount);
        final cost = Currency('USD', Locale('en-us')).unitToInternal(r.cost);
        // I don't think that efficiency needs to be updated because the stats
        // page will handle it, but that could be an issue
        return r.copyWith(mileage: mileage, amount: amount, cost: cost);
      }).forEach((r) {
        refuelingWriteBatch.updateData(r.id, r.toEntity().toDocument());
      });
      await refuelingWriteBatch.commit();

      final cars = await getCurrentCars();
      final carWriteBatch = startCarWriteBatch();
      cars.map((c) {
        final mileage = Distance(DistanceUnit.imperial, Locale('en-us')).unitToInternal(c.mileage);
        // distance rate and efficiency should similarly be updated by the stats
        // calcs here
        return c.copyWith(mileage: mileage);
      }).forEach((c) {
        carWriteBatch.updateData(c.id, c.toEntity().toDocument());
      });
      await carWriteBatch.commit();

      final repeats = await getCurrentRepeats();
      final repeatWriteBatch = startRepeatWriteBatch();
      repeats.map((r) {
        final mileageInterval = Distance(DistanceUnit.imperial, Locale('en-us')).unitToInternal(r.mileageInterval);
        return r.copyWith(mileageInterval: mileageInterval);
      }).forEach((r) {
        repeatWriteBatch.updateData(r.id, r.toEntity().toDocument());
      });
      await repeatWriteBatch.commit();
    }
  }

  @override
  List<Object> get props => [_firestoreInstance, _uuid];

  @override
  String toString() => 'FirebaseDataRepository { firestoreInstance: '
      '$_firestoreInstance, uuid: $_uuid, userDoc: $_userDoc, todos: '
      '$_todos, refuelings: $_refuelings, cars: $_cars, repeats: $_repeats }';
}
