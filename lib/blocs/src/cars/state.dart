import 'package:equatable/equatable.dart';
import '../../../models/models.dart';

abstract class CarsState extends Equatable {
  const CarsState();

  @override
  List<Object> get props => [];
}

class CarsLoading extends CarsState {}

class CarsLoaded extends CarsState {
  const CarsLoaded([this.cars = const []]);

  final List<Car> cars;

  @override
  List<Object> get props => [...cars.map((c) => c.hashCode)];

  @override
  String toString() => 'CarsLoaded { cars: $cars }';
}

class CarsNotLoaded extends CarsState {}
