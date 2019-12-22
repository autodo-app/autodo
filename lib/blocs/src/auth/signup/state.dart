import 'package:equatable/equatable.dart';

abstract class SignupState extends Equatable {
  const SignupState();

  @override 
  List<Object> get props => [];
}

class SignupEmpty extends SignupState {}

class SignupError extends SignupState {
  final String errorMsg;

  const SignupError(this.errorMsg);

  @override
  List<Object> get props => [];
}

class SignupLoading extends SignupState {}

class SignupCredentialsInvalid extends SignupState {
  final String emailError;
  final String passwordError;

  const SignupCredentialsInvalid({this.emailError, this.passwordError});

  SignupCredentialsInvalid copyWith({emailError, passwordError}) => 
    SignupCredentialsInvalid(
      emailError: emailError ?? this.emailError,
      passwordError: passwordError ?? this.passwordError,
  );

  @override 
  List<Object> get props => [];
}

class SignupCredentialsValid extends SignupState {}

class SignupSuccess extends SignupState {}

class VerificationSent extends SignupState {}

class UserVerified extends SignupState {}