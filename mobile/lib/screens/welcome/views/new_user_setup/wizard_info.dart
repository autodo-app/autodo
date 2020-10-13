import 'dart:async';

import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import '../../../../models/models.dart';
import '../../../../redux/redux.dart';
import 'wizard.dart';

class NewUserCar {
  String name = '';
  double mileage;
  double oilChange;
  double tireRotation;
}

class NewUserScreenWizard extends WizardInfo {
  NewUserScreenWizard(WizardState wizard, this.store) : super(wizard);

  final cars = <NewUserCar>[];
  final Store<AppState> store;

  double oilRepeatInterval;
  double tireRotationRepeatInterval;

  @override
  FutureOr<void> onStart(BuildContext context) {
    cars.add(NewUserCar());
  }

  @override
  FutureOr<void> didCancel(BuildContext context) {
    store.dispatch(logOut());
  }

  @override
  FutureOr<void> didFinish(BuildContext context) {
    // TODO: Make this its own addition so that the cars are added first and ID vals are used right

    final newCars = <Car>[];
    final newTodos = <String, List<Todo>>{};
    for (final car in cars) {
      final c = Car(
          name: car.name,
          snaps: [OdomSnapshot(mileage: car.mileage, date: DateTime.now())]);
      newCars.add(c);
      newTodos[c.name] = [];
      if (car.oilChange != null) {
        newTodos[c.name].add(Todo(
          name: 'Oil',
          completedOdomSnapshot: OdomSnapshot(
            mileage: car.mileage,
            date: DateTime.now(),
          ),
          dueMileage: car.oilChange,
          mileageRepeatInterval: oilRepeatInterval,
        ));
      }
      if (car.tireRotation != null) {
        newTodos[c.name].add(Todo(
          name: 'Tire Rotation',
          completedOdomSnapshot: OdomSnapshot(
            mileage: car.mileage,
            date: DateTime.now(),
          ),
          dueMileage: car.tireRotation,
          mileageRepeatInterval: tireRotationRepeatInterval,
        ));
      }
    }

    store.dispatch(setNewUserData(cars: newCars, todos: newTodos));
    // Navigator.of(context).pop();
  }
}
