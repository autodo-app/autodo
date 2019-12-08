import 'package:equatable/equatable.dart';
import 'package:autodo/models/barrel.dart';

abstract class RepeatsState extends Equatable {
  const RepeatsState();

  @override
  List<Object> get props => [];
}

class RepeatsLoading extends RepeatsState {}

class RepeatsLoaded extends RepeatsState {
  final List<Repeat> repeats;

  const RepeatsLoaded([this.repeats = const []]);

  @override
  List<Object> get props => [repeats];

  @override
  String toString() => 'RepeatsLoaded { repeats: $repeats }';
}

class RepeatsNotLoaded extends RepeatsState {}