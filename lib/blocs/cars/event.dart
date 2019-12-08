import 'package:equatable/equatable.dart';
import 'package:autodo/models/barrel.dart';

abstract class CarsEvent extends Equatable {
  const CarsEvent();

  @override
  List<Object> get props => [];
}

class LoadCars extends CarsEvent {}

class AddCar extends CarsEvent {
  final Car car;

  const AddCar(this.car);

  @override
  List<Object> get props => [car];

  @override
  String toString() => 'AddCar { car: $car }';
}

class UpdateCar extends CarsEvent {
  final Car updatedCar;

  const UpdateCar(this.updatedCar);

  @override
  List<Object> get props => [updatedCar];

  @override
  String toString() => 'UpdateCar { updatedCar: $updatedCar }';
}

class DeleteCar extends CarsEvent {
  final Car car;

  const DeleteCar(this.car);

  @override
  List<Object> get props => [car];

  @override
  String toString() => 'DeleteCar { car: $car }';
}

class ClearCompleted extends CarsEvent {}

class ToggleAll extends CarsEvent {}

class CarsUpdated extends CarsEvent {
  final List<Car> cars;

  const CarsUpdated(this.cars);

  @override
  List<Object> get props => [cars];
}