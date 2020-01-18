import 'package:equatable/equatable.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final int lastID;

  const NotificationsLoaded(this.lastID);

  @override
  List<Object> get props => [lastID];
}

class NotificationsNotLoaded extends NotificationsState {}
