import 'package:equatable/equatable.dart';
import 'package:autodo/models/models.dart';

abstract class CarsState extends Equatable {
  const CarsState();

  @override
  List<Object> get props => [];
}

class CarsLoading extends CarsState {}

class CarsLoaded extends CarsState {
  final List<Car> cars;

  const CarsLoaded([this.cars = const []]);

  @override
  List<Object> get props => [...cars];

  @override
  String toString() => 'CarsLoaded { cars: $cars }';
}

class CarsNotLoaded extends CarsState {}
