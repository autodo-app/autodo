import 'package:equatable/equatable.dart';
import 'package:autodo/models/barrel.dart';

abstract class RefuelingsEvent extends Equatable {
  const RefuelingsEvent();

  @override
  List<Object> get props => [];
}

class LoadRefuelings extends RefuelingsEvent {}

class AddRefueling extends RefuelingsEvent {
  final Refueling refueling;

  const AddRefueling(this.refueling);

  @override
  List<Object> get props => [refueling];

  @override
  String toString() => 'AddRefueling { refueling: $refueling }';
}

class UpdateRefueling extends RefuelingsEvent {
  final Refueling refueling;

  const UpdateRefueling(this.refueling);

  @override
  List<Object> get props => [refueling];

  @override
  String toString() => 'UpdateRefueling { refueling: $refueling }';
}

class DeleteRefueling extends RefuelingsEvent {
  final Refueling refueling;

  const DeleteRefueling(this.refueling);

  @override
  List<Object> get props => [refueling];

  @override
  String toString() => 'DeleteRefueling { refueling: $refueling }';
}

class RefuelingsUpdated extends RefuelingsEvent {
  final List<Refueling> refuelings;

  const RefuelingsUpdated(this.refuelings);

  @override
  List<Object> get props => [refuelings];
}

class ExternalCarsUpdated extends RefuelingsEvent {
  final List<Car> cars;

  const ExternalCarsUpdated(this.cars);

  @override 
  List<Object> get props => [cars];
}