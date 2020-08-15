import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_intl/json_intl.dart';

import '../../../../blocs/blocs.dart';
import '../../../../models/models.dart';
import '../../../../units/units.dart';
import 'wizard.dart';

class NewUserCar {
  String name = '';
  double mileage;
  double oilChange;
  double tireRotation;
}

class NewUserScreenWizard extends WizardInfo {
  NewUserScreenWizard(WizardState wizard) : super(wizard);

  final cars = <NewUserCar>[];

  double oilRepeatInterval;
  double tireRotationRepeatInterval;

  @override
  FutureOr<void> onStart(BuildContext context) {
    cars.add(NewUserCar());
  }

  @override
  FutureOr<void> didCancel(BuildContext context) {
    BlocProvider.of<AuthenticationBloc>(context).add(LogOut());
  }

  @override
  FutureOr<void> didFinish(BuildContext context) {
    // TODO: Make this its own addition so that the cars are added first and ID vals are used right

    final newCars = <Car>[];
    final newTodos = <String, Todo>{};
    for (final car in cars) {
      final c = Car(
          name: car.name,
          odomSnapshot:
              OdomSnapshot(mileage: car.mileage, date: DateTime.now()));
      newCars.add(c);
      if (car.oilChange != null) {
        newTodos[c.name] = Todo(
          name: 'Oil',
          completed: true,
          completedOdomSnapshot: OdomSnapshot(
            mileage: car.mileage,
            date: DateTime.now(),
          ),
          dueMileage: car.oilChange,
          mileageRepeatInterval: oilRepeatInterval,
        );
      }
      if (car.tireRotation != null) {
        newTodos[c.name] = Todo(
          name: 'Tire Rotation',
          completed: true,
          completedOdomSnapshot: OdomSnapshot(
            mileage: car.mileage,
            date: DateTime.now(),
          ),
          dueMileage: car.tireRotation,
          mileageRepeatInterval: tireRotationRepeatInterval,
        );
      }
    }
    BlocProvider.of<DataBloc>(context).add(TranslateDefaults(
        JsonIntl.of(context), Distance.of(context, listen: false).unit));
    BlocProvider.of<DataBloc>(context)
        .add(SetNewUserData(cars: newCars, todos: newTodos));
  }
}
