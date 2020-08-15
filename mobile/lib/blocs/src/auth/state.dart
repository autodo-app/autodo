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
class RemoteAuthenticated extends Authenticated {
  const RemoteAuthenticated(this.displayName, this.token);

  /// The email address of the user. Used to represent the user in the GUI.
  final String displayName;

  /// The token used to authenticate requests to the server
  final String token;

  @override
  List<Object> get props => [displayName, token];

  @override
  String toString() =>
      '$runtimeType { displayName: $displayName, token: $token }';
}

class LocalAuthenticated extends Authenticated {
  const LocalAuthenticated();

  @override
  List<Object> get props => [];

  @override
  String toString() => '$runtimeType { }';
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
  String toString() => '$runtimeType { errorCode: $errorCode }';
}
