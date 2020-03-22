import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:autodo/units/units.dart';
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

  // Notifications
  Stream<int> notificationID();

  // Paid or Ad-supported version
  Future<bool> getPaidStatus();

  Future<void> upgrade(int curVer, int desVer) async {
    if (curVer == 1 && desVer == 2) {
      // Move to SI units internally
      final todos = await getCurrentTodos();
      final todoWriteBatch = await startTodoWriteBatch();
      todos.map((t) {
        final dueMileage = Distance(DistanceUnit.imperial, Locale('en-us'))
            .unitToInternal(t.dueMileage);
        return t.copyWith(dueMileage: dueMileage);
      }).forEach((t) {
        todoWriteBatch.updateData(t.id, t.toDocument());
      });
      await todoWriteBatch.commit();

      final refuelings = await getCurrentRefuelings();
      final refuelingWriteBatch = await startRefuelingWriteBatch();
      refuelings.map((r) {
        final mileage = Distance(DistanceUnit.imperial, Locale('en-us'))
            .unitToInternal(r.mileage);
        final amount = Volume(VolumeUnit.imperial, Locale('en-us'))
            .unitToInternal(r.amount);
        // I don't think that efficiency needs to be updated because the stats
        // page will handle it, but that could be an issue
        return r.copyWith(mileage: mileage, amount: amount);
      }).forEach((r) {
        refuelingWriteBatch.updateData(r.id, r.toDocument());
      });
      await refuelingWriteBatch.commit();

      final cars = await getCurrentCars();
      final carWriteBatch = await startCarWriteBatch();
      cars.map((c) {
        final mileage = Distance(DistanceUnit.imperial, Locale('en-us'))
            .unitToInternal(c.mileage);
        // distance rate and efficiency should similarly be updated by the stats
        // calcs here
        return c.copyWith(mileage: mileage);
      }).forEach((c) {
        carWriteBatch.updateData(c.id, c.toDocument());
      });
      await carWriteBatch.commit();

      // TODO 275: pull the repeat content directly from db without a model?
      // final repeats = await getCurrentRepeats();
      // final repeatWriteBatch = await startRepeatWriteBatch();
      // repeats.map((r) {
      //   final mileageInterval = Distance(DistanceUnit.imperial, Locale('en-us'))
      //       .unitToInternal(r.mileageInterval);
      //   return r.copyWith(mileageInterval: mileageInterval);
      // }).forEach((r) {
      //   repeatWriteBatch.updateData(r.id, r.toDocument());
      // });
      // await repeatWriteBatch.commit();
    }
  }
}
