import 'package:equatable/equatable.dart';

abstract class PaidVersionState extends Equatable {
  const PaidVersionState();

  @override
  List<Object> get props => [];
}

class PaidVersionLoading extends PaidVersionState {}

class PaidVersion extends PaidVersionState {}

class BasicVersion extends PaidVersionState {}
