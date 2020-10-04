import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import '../../models/models.dart';

class DataState extends Equatable {
  const DataState(
      {@required this.todos,
      @required this.refuelings,
      @required this.cars,
      @required this.status,
      @required this.error});

  final List<Todo> todos;
  final List<Refueling> refuelings;
  final List<Car> cars;
  final String status;
  final String error;

  DataState copyWith(
          {List<Todo> todos,
          List<Refueling> refuelings,
          List<Car> cars,
          String status,
          String error}) =>
      DataState(
          todos: todos ?? this.todos,
          refuelings: refuelings ?? this.refuelings,
          cars: cars ?? this.cars,
          status: status ?? this.status,
          error: error ?? this.error);

  @override
  List<Object> get props => [todos, refuelings, cars, status, error];
}
