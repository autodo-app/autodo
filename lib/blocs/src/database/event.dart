import 'package:equatable/equatable.dart';

abstract class DatabaseEvent extends Equatable {
  const DatabaseEvent();

  @override
  List<Object> get props => [];
}

class UserLoggedIn extends DatabaseEvent {
  const UserLoggedIn(this.uuid);

  final String uuid;

  @override
  List<Object> get props => [uuid];

  @override
  String toString() => '$runtimeType { uuid: $uuid }';
}

class UserLoggedOut extends DatabaseEvent {}

class TrialLogin extends DatabaseEvent {
  const TrialLogin();

  @override
  List<Object> get props => [];

  @override
  String toString() => '$runtimeType { }';
}
