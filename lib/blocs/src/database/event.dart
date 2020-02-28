import 'package:equatable/equatable.dart';

abstract class DatabaseEvent extends Equatable {
  const DatabaseEvent();

  @override
  List<Object> get props => [];
}

class UserLoggedIn extends DatabaseEvent {
  const UserLoggedIn(this.uuid, [this.newUser]);

  final String uuid;

  final bool newUser;

  @override
  List<Object> get props => [uuid, newUser];

  @override
  String toString() => 'UserLoggedIn { uuid: $uuid, newUser: $newUser }';
}

class UserLoggedOut extends DatabaseEvent {}

class TrialLogin extends DatabaseEvent {
  const TrialLogin(this.newUser);

  final bool newUser;

  @override
  List<Object> get props => [newUser];

  @override
  String toString() => 'TrialLogin { newUser: $newUser }';
}
