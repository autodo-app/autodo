import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../../../models/models.dart';

abstract class RepeatsState extends Equatable {
  const RepeatsState();

  @override
  List<Object> get props => [];
}

class RepeatsLoading extends RepeatsState {}

class RepeatsLoaded extends RepeatsState {
  const RepeatsLoaded([this.repeats = const [], this.changes = const []]);

  final List<Repeat> repeats;

  // TODO: figure out how feasible it is to implement this as a means
  // of figuring out what repeats have/haven't been updated
  final List<DocumentChange> changes;

  List<Repeat> sorted() {
    return repeats
      ..sort((a, b) {
        if (a.mileageInterval > b.mileageInterval) {
          return 1;
        } else if (a.mileageInterval < b.mileageInterval) {
          return -1;
        } else {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        }
      });
  }

  // use spread operator so differences in individual repeats matter
  @override
  List<Object> get props =>
      (repeats == null) ? [null] : repeats.map((r) => r.props).toList();

  @override
  String toString() => 'RepeatsLoaded { repeats: $repeats }';
}

class RepeatsNotLoaded extends RepeatsState {}
