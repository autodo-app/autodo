import 'package:equatable/equatable.dart';

abstract class DatabaseEvent extends Equatable {
  const DatabaseEvent();

  @override
  List<Object> get props => [];
}

class UserLoggedIn extends DatabaseEvent {
  final String uuid;
  final bool newUser;

  const UserLoggedIn(this.uuid, [this.newUser]);

  @override
  List<Object> get props => [uuid, newUser];

  @override
  toString() => "UserLoggedIn { uuid: $uuid, newUser: $newUser }";
}

class UserLoggedOut extends DatabaseEvent {}
