import 'package:equatable/equatable.dart';
import 'package:autodo/models/models.dart';

abstract class RefuelingsEvent extends Equatable {
  const RefuelingsEvent();

  @override
  List<Object> get props => [];
}

class LoadRefuelings extends RefuelingsEvent {}

class AddRefueling extends RefuelingsEvent {
  const AddRefueling(this.refueling);

  final Refueling refueling;

  @override
  List<Object> get props => [refueling];

  @override
  String toString() => 'AddRefueling { refueling: $refueling }';
}

class UpdateRefueling extends RefuelingsEvent {
  const UpdateRefueling(this.refueling);

  final Refueling refueling;

  @override
  List<Object> get props => [refueling];

  @override
  String toString() => 'UpdateRefueling { refueling: $refueling }';
}

class DeleteRefueling extends RefuelingsEvent {
  const DeleteRefueling(this.refueling);

  final Refueling refueling;

  @override
  List<Object> get props => [refueling];

  @override
  String toString() => 'DeleteRefueling { refueling: $refueling }';
}

class ExternalCarsUpdated extends RefuelingsEvent {
  const ExternalCarsUpdated(this.cars);

  final List<Car> cars;

  @override
  List<Object> get props => [cars];

  @override
  String toString() => 'ExternalCarsUpdated { cars: $cars }';
}
