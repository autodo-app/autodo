import 'package:cloud_firestore/cloud_firestore.dart';
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
  // TODO: figure out how feasible it is to implement this as a means
  // of figuring out what repeats have/haven't been updated
  final List<DocumentChange> changes;

  const RepeatsLoaded([this.repeats = const [], this.changes]);

  @override
  List<Object> get props => [repeats];

  @override
  String toString() => 'RepeatsLoaded { repeats: $repeats }';
}

class RepeatsNotLoaded extends RepeatsState {}