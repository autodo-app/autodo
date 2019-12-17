import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class SignupEmailChanged extends SignupEvent {
  final String email;

  const SignupEmailChanged({@required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'SignupEmailChanged { email :$email }';
}

class SignupPasswordChanged extends SignupEvent {
  final String password;

  const SignupPasswordChanged({@required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'SignupPasswordChanged { password: $password }';
}

class SignupSubmitted extends SignupEvent {
  final String email;
  final String password;

  const SignupSubmitted({
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [email, password];

  @override
  String toString() {
    return 'SignupSubmitted { email: $email, password: $password }';
  }
}

class SignupWithCredentialsPressed extends SignupEvent {
  final String email;
  final String password;

  const SignupWithCredentialsPressed({
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [email, password];

  @override
  String toString() {
    return 'SignupWithCredentialsPressed { email: $email, password: $password }';
  }
}