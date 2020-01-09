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

import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

/// Prompts a change to the state of a [LoginBloc].
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

/// Tells the [LoginBloc] that the email field of the [LoginForm] has changed.
class LoginEmailChanged extends LoginEvent {
  /// The text currently present in the email field of the [LoginForm].
  final String email;

  const LoginEmailChanged({@required this.email});

  @override
  List<Object> get props => [email];
}

/// Tells the [LoginBloc] that the password field of the [LoginForm] has changed.
class LoginPasswordChanged extends LoginEvent {
  /// The text currently present in the password field of the [LoginForm].
  final String password;

  const LoginPasswordChanged({@required this.password});

  @override
  List<Object> get props => [password];
}

/// Tells the [LoginBloc] that the user would like to sign in with Google.
class LoginWithGooglePressed extends LoginEvent {}

/// Tells the [LoginBloc] to submit the contents of the [LoginForm] and
/// authenticate the user.
class LoginWithCredentialsPressed extends LoginEvent {
  /// The email address for the user to be signed in.
  final String email;

  /// The password for the user account to be signed in.
  final String password;

  const LoginWithCredentialsPressed({
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

/// Prompts the [LoginBloc] to send a password reset email for the given 
/// address.
class SendPasswordResetPressed extends LoginEvent {
  /// The email address where the password reset email will be sent.
  final String email;

  const SendPasswordResetPressed({@required this.email});

  @override
  List<Object> get props => [email];
}
