import 'package:equatable/equatable.dart';
import 'package:autodo/models/models.dart';

abstract class RefuelingsState extends Equatable {
  const RefuelingsState();

  @override
  List<Object> get props => [];
}

class RefuelingsLoading extends RefuelingsState {}

class RefuelingsLoaded extends RefuelingsState {
  final List<Refueling> refuelings;

  const RefuelingsLoaded([this.refuelings = const []]);

  @override
  List<Object> get props => [refuelings];

  @override
  String toString() => 'RefuelingsLoaded { todos: $refuelings }';
}

class RefuelingsNotLoaded extends RefuelingsState {}