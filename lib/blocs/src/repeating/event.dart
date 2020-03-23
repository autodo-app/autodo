import 'package:equatable/equatable.dart';
import '../../../models/models.dart';

abstract class RepeatsEvent extends Equatable {
  const RepeatsEvent();

  @override
  List<Object> get props => [];
}

class LoadRepeats extends RepeatsEvent {}

class AddRepeat extends RepeatsEvent {
  const AddRepeat(this.repeat);

  final Repeat repeat;

  @override
  List<Object> get props => [repeat];

  @override
  String toString() => 'AddRepeat { repeat: $repeat }';
}

class UpdateRepeat extends RepeatsEvent {
  const UpdateRepeat(this.updatedRepeat);

  final Repeat updatedRepeat;

  @override
  List<Object> get props => [updatedRepeat];

  @override
  String toString() => 'UpdateRepeat { updatedRepeat: $updatedRepeat }';
}

class DeleteRepeat extends RepeatsEvent {
  const DeleteRepeat(this.repeat);

  final Repeat repeat;

  @override
  List<Object> get props => [repeat];

  @override
  String toString() => 'DeleteRepeat { repeat: $repeat }';
}

class AddDefaultRepeats extends RepeatsEvent {}

class RepeatCarsUpdated extends RepeatsEvent {
  const RepeatCarsUpdated(this.cars);

  final List<Car> cars;

  @override
  List<Object> get props => [cars];

  @override
  String toString() => 'Repeat Cars Updated { cars: $cars }';
}
