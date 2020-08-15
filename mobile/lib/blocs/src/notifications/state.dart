import 'package:equatable/equatable.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  const NotificationsLoaded(this.lastID);

  final int lastID;

  @override
  List<Object> get props => [lastID];
}

class NotificationsNotLoaded extends NotificationsState {}
