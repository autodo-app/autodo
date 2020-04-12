import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/models.dart';
import '../../units/units.dart';
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

  @deprecated
  Future<List<Map<String, dynamic>>> getRepeats();

  @protected
  Future<int> upgrade(int curVer, int desVer) async {
    if (curVer == 1 && desVer >= 2) {
      // Move to SI units internally
      final todos = await getCurrentTodos();
      final todoWriteBatch = await startTodoWriteBatch();
      todos.map((t) {
        final dueMileage =
            t.dueMileage == null ? null : t.dueMileage * Distance.miles;
        return t.copyWith(dueMileage: dueMileage);
      }).forEach((t) {
        todoWriteBatch.updateData(t.id, t.toDocument());
      });
      await todoWriteBatch.commit();

      final refuelings = await getCurrentRefuelings();
      final refuelingWriteBatch = await startRefuelingWriteBatch();
      refuelings.map((r) {
        final mileage = r.mileage == null ? null : r.mileage * Distance.miles;
        final amount =
            r.amount == null ? null : r.amount * Volume.usLiquidGallon;
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
        final mileage = c.mileage == null ? null : c.mileage * Distance.miles;
        // distance rate and efficiency should similarly be updated by the stats
        // calcs here
        return c.copyWith(mileage: mileage);
      }).forEach((c) {
        carWriteBatch.updateData(c.id, c.toDocument());
      });
      await carWriteBatch.commit();
    }
    if (curVer < 3 && desVer == 3) {
      // Remove Repeats in favor of new Todo fields
      final repeats =
          await getRepeats(); // ignore:deprecated_member_use_from_same_package
      final todos = await getCurrentTodos();
      final batch = await startTodoWriteBatch();
      repeats.forEach((r) {
        final todo = todos
            .firstWhere((t) => t.name == r['name'] && !(t.completed ?? false));
        final updatedTodo = todo.copyWith(
            mileageRepeatInterval: r['mileageInterval'].toDouble(),
            dateRepeatInterval: r['dateInterval']);
        batch.updateData(updatedTodo.id, updatedTodo.toDocument());
      });
      await batch.commit();
    }

    return desVer;
  }
}
