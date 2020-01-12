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

/// Prompts a change to the state of a [SignupBloc].
abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

/// Tells the [SignupBloc] that the email field of the [SignupForm] has changed.
class SignupEmailChanged extends SignupEvent {
  /// The text currently present in the email field of the [SignupForm].
  final String email;

  const SignupEmailChanged({@required this.email});

  @override
  List<Object> get props => [email];
}

/// Tells the [SignupBloc] that the password field of the [SignupForm] has changed.
class SignupPasswordChanged extends SignupEvent {
  /// The text currently present in the password field of the [SignupForm].
  final String password;

  const SignupPasswordChanged({@required this.password});

  @override
  List<Object> get props => [password];
}

/// Tells the [SignupBloc] to submit the contents of the [SignupForm] and
/// authenticate the user.
class SignupWithCredentialsPressed extends SignupEvent {
  /// The email address for the user to be signed up.
  final String email;

  /// The password for the user to be signed up.
  final String password;

  const SignupWithCredentialsPressed({
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [email, password];
}
