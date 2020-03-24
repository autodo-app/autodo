import 'package:equatable/equatable.dart';
import '../../../models/models.dart';

abstract class CarsEvent extends Equatable {
  const CarsEvent();

  @override
  List<Object> get props => [];
}

class LoadCars extends CarsEvent {}

class AddCar extends CarsEvent {
  const AddCar(this.car);

  final Car car;

  @override
  List<Object> get props => [car];

  @override
  String toString() => 'AddCar { car: $car }';
}

class UpdateCar extends CarsEvent {
  const UpdateCar(this.updatedCar);

  final Car updatedCar;

  @override
  List<Object> get props => [updatedCar];

  @override
  String toString() => 'UpdateCar { updatedCar: $updatedCar }';
}

class DeleteCar extends CarsEvent {
  const DeleteCar(this.car);

  final Car car;

  @override
  List<Object> get props => [car];

  @override
  String toString() => 'DeleteCar { car: $car }';
}

class ExternalRefuelingsUpdated extends CarsEvent {
  const ExternalRefuelingsUpdated(this.refuelings);

  final List<Refueling> refuelings;

  @override
  List<Object> get props => [refuelings];

  @override
  String toString() => 'ExternalRefuelingsUpdated { refuelings: $refuelings }';
}
