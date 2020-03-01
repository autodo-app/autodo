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

/// Represents whether or not there is a user logged into the app.
abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

/// The initial state of the [AuthenticationBloc] prior to receiving the
/// [AppStarted] event.
class Uninitialized extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  const Authenticated();
}

/// Represents an app state where there is a user logged in.
class RemoteAuthenticated extends AuthenticationState {
  const RemoteAuthenticated(this.displayName, this.uuid, this.newUser);

  /// The email address of the user. Used to represent the user in the GUI.
  final String displayName;

  /// A unique string of alphanumeric characters identifying the user. Only used
  /// for internal purposes.
  final String uuid;

  /// A flag that is raised when this is the first time the app is run with the
  /// currently authenticated user. This flag is responsible for triggering
  /// setup routines to prepare the initial set of data for the user's account.
  final bool newUser;

  @override
  List<Object> get props => [displayName, uuid, newUser];

  @override
  String toString() =>
      'RemoteAuthenticated { displayName: $displayName, uuid: $uuid, newUser: $newUser }';
}

class LocalAuthenticated extends Authenticated {
  const LocalAuthenticated(this.newUser);

  final bool newUser;

  @override
  List<Object> get props => [newUser];

  @override
  String toString() => 'LocalAuthenticated { newUser: $newUser }';
}

/// Represents an app state where there is not a user logged in.
class Unauthenticated extends AuthenticationState {
  const Unauthenticated({this.errorCode});

  /// An optional parameter for the event that describes why an authenticated
  /// user could not be found if it is the result of an error.
  final String errorCode;

  @override
  List<Object> get props => [errorCode];

  @override
  String toString() => 'Unauthenticated { errorCode: $errorCode }';
}
