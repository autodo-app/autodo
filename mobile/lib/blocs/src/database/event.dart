import 'package:equatable/equatable.dart';

abstract class DatabaseEvent extends Equatable {
  const DatabaseEvent();

  @override
  List<Object> get props => [];
}

class UserLoggedIn extends DatabaseEvent {
  const UserLoggedIn(this.token);

  final String token;

  @override
  List<Object> get props => [token];

  @override
  String toString() => '$runtimeType { token: $token }';
}

class UserLoggedOut extends DatabaseEvent {}

class TrialLogin extends DatabaseEvent {
  const TrialLogin();

  @override
  List<Object> get props => [];

  @override
  String toString() => '$runtimeType { }';
}
