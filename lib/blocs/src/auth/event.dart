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

/// Prompts a change to the state of an [AuthenticationBloc]. 
abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

/// Tells the [AuthenticationBloc] to check for a signed in user.
/// 
/// Also used to prep a dummy user for an integration test if applicable.
class AppStarted extends AuthenticationEvent {
  /// A flag used to change the transformation's behavior to prep a dummy user
  /// in the case of an integration test.
  final bool integrationTest;

  const AppStarted({this.integrationTest});

  @override
  List<Object> get props => [integrationTest];

  @override
  String toString() => 'AppStarted { integrationTest: $integrationTest }';
}

/// Added when a [UserRepository] stream notifies of a signed in user.
class LoggedIn extends AuthenticationEvent {}

/// Added when a [UserRepository] stream notifies of a new user.
class SignedUp extends AuthenticationEvent {}

/// Tells the [AuthenticationBloc] to sign out the currently authenticated user.
class LogOut extends AuthenticationEvent {}

/// Tells the [AuthenticationBloc] to delete the data associated with the 
/// currently authenticated user.
class DeletedUser extends AuthenticationEvent {}

/// Added when a [UserRepository] stream notifies of a login with the Google
/// Account Auth Provider.
class SignInWithGoogle extends AuthenticationEvent {}
