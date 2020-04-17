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
    final newCars = [];
    final newTodos = [];
    newCars.addAll(cars.map((c) => Car(name: c.name, mileage: c.mileage)));
    newTodos.addAll(cars.map((c) =>
      (c.oilChange != null) ?
        Todo(
          name: 'oil',
          carName: c.name,
          completed: true,
          completedDate: DateTime.now(),
          dueMileage: c.oilChange,
          mileageRepeatInterval: oilRepeatInterval,
        ) : null));
    newTodos.addAll(cars.map((c) =>
      (c.tireRotation != null) ?
        Todo(
          name: 'tireRotation',
          carName: c.name,
          completed: true,
          completedDate: DateTime.now(),
          dueMileage: c.tireRotation,
          mileageRepeatInterval: tireRotationRepeatInterval,
        ) : null));
    newTodos.removeWhere((t) => t == null);
    BlocProvider.of<TodosBloc>(context).add(TranslateDefaults(JsonIntl.of(context), Distance.of(context).unit));
    BlocProvider.of<CarsBloc>(context).add(AddMultipleCars(newCars));
    BlocProvider.of<TodosBloc>(context).add(AddMultipleTodos(newTodos));
  }
}
