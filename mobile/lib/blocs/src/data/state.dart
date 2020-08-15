import 'package:equatable/equatable.dart';

import '../../../models/models.dart';

abstract class DataState extends Equatable {
  const DataState();

  @override
  List<Object> get props => [];
}

class DataLoading extends DataState {
  const DataLoading({this.defaultTodos = const []});

  final List<Todo> defaultTodos;

  @override
  List<Object> get props => defaultTodos;

  @override
  String toString() => 'DataLoading { defaultTodos: $defaultTodos }';
}

class DataLoaded extends DataState {
  const DataLoaded(
      {this.cars = const [],
      this.refuelings = const [],
      this.todos = const [],
      this.defaultTodos = const []});

  final List<Car> cars;

  final List<Refueling> refuelings;

  final List<Todo> todos;

  final List<Todo> defaultTodos;

  DataLoaded copyWith(
          {List<Car> cars,
          List<Refueling> refuelings,
          List<Todo> todos,
          List<Todo> defaultTodos}) =>
      DataLoaded(
          cars: cars ?? this.cars,
          refuelings: refuelings ?? this.refuelings,
          todos: todos ?? this.todos,
          defaultTodos: defaultTodos ?? this.defaultTodos);

  @override
  List<Object> get props => [...cars, ...refuelings, ...todos, ...defaultTodos];

  @override
  String toString() =>
      'DataLoaded { cars: $cars, refuelings: $refuelings, todos: $todos , defaultTodos: $defaultTodos }';
}

class DataNotLoaded extends DataState {}
