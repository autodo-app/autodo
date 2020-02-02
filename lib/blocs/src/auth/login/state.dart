// Copyright 2020 Jonathan Bayless
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:autodo/blocs/blocs.dart';
import 'package:equatable/equatable.dart';

/// Represents the current state of the [LoginForm] fields and validation.
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

/// Initial state for the [LoginBloc] indicating that the [LoginForm] fields are
/// empty.
class LoginEmpty extends LoginState {}

/// Indicates that there was an error with the submission of the contents of the
/// [LoginForm].
///
/// This does not indicate a fatal error, the [errorMsg] string is displayed
/// as direction to the user for resolving the error.
class LoginError extends LoginState {
  /// A description of the cause and/or resolution of the login error.
  final String errorMsg;

  const LoginError(this.errorMsg);

  @override
  List<Object> get props => [];
}

/// Indicates that the [LoginBloc] has sent an action to the authentication
/// database and is waiting for a response.
class LoginLoading extends LoginState {}

/// Indicates that there was an error with the validation of one of the fields
/// in the [LoginForm].
class LoginCredentialsInvalid extends LoginState {
  /// An optional parameter describing the error with the email field if applicable.
  final String emailError;

  /// The current email
  final String email;

  /// An optional parameter describing the error with the password field if applicable.
  final String passwordError;


  /// The current password
  final String password;

  const LoginCredentialsInvalid({this.emailError, this.passwordError, this.email, this.password});

  LoginCredentialsInvalid copyWith({emailError, passwordError, email, password}) =>
      LoginCredentialsInvalid(
        emailError: emailError ?? this.emailError,
        passwordError: passwordError ?? this.passwordError,
        email: email ?? this.email,
        password: password ?? this.password
      );

  @override
  List<Object> get props => [];
}

/// Indicates that the contents of the [LoginForm] are properly validated and
/// ready for submission to the authentication database.
class LoginCredentialsValid extends LoginState {
  final String email, password;

  const LoginCredentialsValid({this.email, this.password});

  LoginCredentialsValid copyWith({email, password}) => 
    LoginCredentialsValid(  
      email: email ?? this.email,
      password: password ?? this.password
    );

  @override 
  List<Object> get props => [email, password];
}

/// The response from the authentication database indicated a successful login
/// for the specified user.
class LoginSuccess extends LoginState {}
