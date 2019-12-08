import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'data_repository.dart';
import 'package:autodo/models/barrel.dart';
import 'package:autodo/entities/barrel.dart';

class FirebaseDataRepository implements DataRepository {
  final todoCollection = Firestore.instance.collection('todos');
  final refuelingCollection = Firestore.instance.collection('refuelings');

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
}