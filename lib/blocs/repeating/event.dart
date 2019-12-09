import 'package:equatable/equatable.dart';
import 'package:autodo/models/barrel.dart';

abstract class RepeatsEvent extends Equatable {
  const RepeatsEvent();

  @override
  List<Object> get props => [];
}

class LoadRepeats extends RepeatsEvent {}

class AddRepeat extends RepeatsEvent {
  final Repeat repeat;

  const AddRepeat(this.repeat);

  @override
  List<Object> get props => [repeat];

  @override
  String toString() => 'AddRepeat { repeat: $repeat }';
}

class UpdateRepeat extends RepeatsEvent {
  final Repeat updatedRepeat;

  const UpdateRepeat(this.updatedRepeat);

  @override
  List<Object> get props => [updatedRepeat];

  @override
  String toString() => 'UpdateRepeat { updatedRepeat: $updatedRepeat }';
}

class DeleteRepeat extends RepeatsEvent {
  final Repeat repeat;

  const DeleteRepeat(this.repeat);

  @override
  List<Object> get props => [repeat];

  @override
  String toString() => 'DeleteRepeat { repeat: $repeat }';
}

class RepeatsUpdated extends RepeatsEvent {
  final List<Repeat> repeats;

  const RepeatsUpdated(this.repeats);

  @override
  List<Object> get props => [repeats];
}

class AddDefaultRepeats extends RepeatsEvent {}