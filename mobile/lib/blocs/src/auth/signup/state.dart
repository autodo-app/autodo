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

import 'package:equatable/equatable.dart';

abstract class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object> get props => [];
}

class SignupEmpty extends SignupState {}

class SignupError extends SignupState {
  const SignupError(this.errorMsg);

  final String errorMsg;

  @override
  List<Object> get props => [];
}

class SignupLoading extends SignupState {}

class SignupCredentialsInvalid extends SignupState {
  const SignupCredentialsInvalid({this.emailError, this.passwordError});

  final String emailError;

  final String passwordError;

  SignupCredentialsInvalid copyWith(
          {String emailError, String passwordError}) =>
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
