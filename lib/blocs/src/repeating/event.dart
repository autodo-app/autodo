import 'package:equatable/equatable.dart';
import 'package:autodo/models/models.dart';

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

class AddDefaultRepeats extends RepeatsEvent {}

class RepeatCarsUpdated extends RepeatsEvent {
  final List<Car> cars;

  const RepeatCarsUpdated(this.cars);

  @override 
  List<Object> get props => [cars];

  @override 
  String toString() => 'Repeat Cars Updated { cars: $cars }';
}
