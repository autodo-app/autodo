import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {
  final bool integrationTest;

  const AppStarted({this.integrationTest});

  @override
  List<Object> get props => [integrationTest];

  @override 
  String toString() => 'AppStarted { integrationTest: $integrationTest }';
}

class LoggedIn extends AuthenticationEvent {}

class LoggedOut extends AuthenticationEvent {}

class DeletedUser extends AuthenticationEvent {}

class SignInWithGoogle extends AuthenticationEvent {}