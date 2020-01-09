import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class Uninitialized extends AuthenticationState {}

abstract class Authenticated extends AuthenticationState {
  const Authenticated();
}

class RemoteAuthenticated extends Authenticated {
  final String displayName, uuid;
  final bool newUser;

  const RemoteAuthenticated(this.displayName, this.uuid, this.newUser);

  @override
  List<Object> get props => [displayName, uuid, newUser];

  @override
  String toString() =>
      'RemoteAuthenticated { displayName: $displayName, uuid: $uuid, newUser: $newUser }';
}

class LocalAuthenticated extends Authenticated {
  final bool newUser;

  const LocalAuthenticated(this.newUser);

  @override 
  List<Object> get props => [newUser];

  @override 
  toString() => 'LocalAuthenticated { newUser: $newUser }';
}

class Unauthenticated extends AuthenticationState {
  final String errorCode;

  const Unauthenticated({this.errorCode});

  @override
  List<Object> get props => [errorCode];

  @override
  String toString() => 'Unauthenticated { errorCode: $errorCode }';
}
