import 'package:equatable/equatable.dart';
import 'package:json_intl/json_intl.dart';
import 'package:flutter/foundation.dart';

import '../../../models/models.dart';
import '../../../units/units.dart';

/// Base class for a [Bloc] event that updates the user's data in the db.
abstract class DataEvent extends Equatable {
  const DataEvent();

  @override
  List<Object> get props => [];
}

class LoadData extends DataEvent {}

// Todos

class AddTodo extends DataEvent {
  const AddTodo(this.todo);

  final Todo todo;

  @override
  List<Object> get props => [todo];

  @override
  String toString() => 'AddTodo { todo: $todo }';
}

class UpdateTodo extends DataEvent {
  const UpdateTodo(this.todo);

  final Todo todo;

  @override
  List<Object> get props => [todo];

  @override
  String toString() => 'UpdateTodo { todo: $todo }';
}

class DeleteTodo extends DataEvent {
  const DeleteTodo(this.todo);

  final Todo todo;

  @override
  List<Object> get props => [todo];

  @override
  String toString() => 'DeleteTodo { todo: $todo }';
}

class CompleteTodo extends DataEvent {
  const CompleteTodo({@required this.todo, this.completedDate, this.completedMileage}):
      assert(todo != null);

  final Todo todo;

  final DateTime completedDate;

  final double completedMileage;

  @override
  List<Object> get props => [todo, completedDate, completedMileage];

  @override
  String toString() =>
      'CompleteTodo { todo: $todo, completedDate: $completedDate, completedMileage: $completedMileage }';
}

class TranslateDefaults extends DataEvent {
  const TranslateDefaults(this.jsonIntl, this.distanceUnit);

  final JsonIntl jsonIntl;
  final DistanceUnit distanceUnit;

  @override
  List<Object> get props => [jsonIntl];

  @override
  String toString() => 'Translate Defaults { JsonIntl: $jsonIntl }';
}

class ToggleAllTodosComplete extends DataEvent {}

// Refuelings

class AddRefueling extends DataEvent {
  const AddRefueling(this.refueling);

  final Refueling refueling;

  @override
  List<Object> get props => [refueling];

  @override
  String toString() => 'AddRefueling { refueling: $refueling }';
}

class UpdateRefueling extends DataEvent {
  const UpdateRefueling({this.refueling, this.odomSnapshot});

  final Refueling refueling;

  final OdomSnapshot odomSnapshot;

  @override
  List<Object> get props => [refueling, odomSnapshot];

  @override
  String toString() =>
      'UpdateRefueling { refueling: $refueling, odomSnapshot: $odomSnapshot }';
}

class DeleteRefueling extends DataEvent {
  const DeleteRefueling(this.refueling);

  final Refueling refueling;

  @override
  List<Object> get props => [refueling];

  @override
  String toString() => 'DeleteRefueling { refueling: $refueling }';
}

// Cars

class AddCar extends DataEvent {
  const AddCar(this.car);

  final Car car;

  @override
  List<Object> get props => [car];

  @override
  String toString() => 'AddCar { car: $car }';
}

class UpdateCar extends DataEvent {
  const UpdateCar(this.car);

  final Car car;

  @override
  List<Object> get props => [car];

  @override
  String toString() => 'UpdateCar { car: $car }';
}

class DeleteCar extends DataEvent {
  const DeleteCar(this.car);

  final Car car;

  @override
  List<Object> get props => [car];

  @override
  String toString() => 'DeleteCar { car: $car }';
}

class SetNewUserData extends DataEvent {
  const SetNewUserData({this.cars, this.todos});

  final List<Car> cars;

  final Map<String, Todo> todos;

  @override 
  List<Object> get props => [...cars, ...todos.entries];

  @override 
  String toString() => '$runtimeType: { cars: $cars, todos: $todos }';
}