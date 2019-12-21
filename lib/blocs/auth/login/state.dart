import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override 
  List<Object> get props => [];
}

class LoginEmpty extends LoginState {}

class LoginError extends LoginState {
  final String errorMsg;

  const LoginError(this.errorMsg);

  @override
  List<Object> get props => [];
}

class LoginLoading extends LoginState {}

class LoginCredentialsInvalid extends LoginState {
  final String emailError;
  final String passwordError;

  const LoginCredentialsInvalid({this.emailError, this.passwordError});

  LoginCredentialsInvalid copyWith({emailError, passwordError}) => 
    LoginCredentialsInvalid(
      emailError: emailError ?? this.emailError,
      passwordError: passwordError ?? this.passwordError,
  );

  @override 
  List<Object> get props => [];
}

class LoginCredentialsValid extends LoginState {}

class LoginSuccess extends LoginState {}