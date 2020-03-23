import 'package:equatable/equatable.dart';
import '../../../models/models.dart';

abstract class RefuelingsState extends Equatable {
  const RefuelingsState();

  @override
  List<Object> get props => [];
}

class RefuelingsLoading extends RefuelingsState {}

class RefuelingsLoaded extends RefuelingsState {
  const RefuelingsLoaded([this.refuelings = const []]);

  final List<Refueling> refuelings;

  @override
  List<Object> get props => [...refuelings];

  @override
  String toString() => 'RefuelingsLoaded { refuelings: $refuelings }';
}

class RefuelingsNotLoaded extends RefuelingsState {}
