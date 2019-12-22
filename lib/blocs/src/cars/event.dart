import 'package:equatable/equatable.dart';
import 'package:autodo/models/models.dart';

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

class ExternalRefuelingsUpdated extends CarsEvent {
  final List<Refueling> refuelings;

  ExternalRefuelingsUpdated(this.refuelings);

  @override
  List<Object> get props => [refuelings];

  @override 
  String toString() => 'ExternalRefuelingsUpdated { refuelings: $refuelings }';
}