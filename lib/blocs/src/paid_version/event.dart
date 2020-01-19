import 'package:equatable/equatable.dart';

abstract class PaidVersionEvent extends Equatable {
  const PaidVersionEvent();

  @override
  List<Object> get props => [];
}

class LoadPaidVersion extends PaidVersionEvent {}

class PaidVersionUpgrade extends PaidVersionEvent {}

class PaidVersionPurchased extends PaidVersionEvent {}
