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

import 'dart:async';

import 'package:autodo/repositories/repositories.dart';
import 'package:flutter/foundation.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../barrel.dart';
import 'package:autodo/blocs/validators.dart';
import 'event.dart';
import 'state.dart';

/// A [Bloc] used for handling the logic of the [LoginScreen] GUI.
///
/// This Bloc is intended to have an [AuthenticationBloc] as a parent that is
/// listening to the same [authRepository] as this Bloc.
///
/// This Bloc handles the login form validation and saving when interacting with
/// the GUI, and is responsible for delegating the proper login action to the
/// [authRepository] upon submission of the [LoginForm].
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  AuthRepository authRepository;

  /// Creates a LoginBloc.
  ///
  /// The [authRepository] parameter must be non-null.
  LoginBloc({@required this.authRepository}) : assert(authRepository != null);

  @override
  LoginState get initialState => LoginEmpty();

  /// Debounces the input events.
  ///
  /// This is to avoid trying to update the results of the validator in the GUI
  /// too quickly.
  @override
  Stream<LoginState> transformEvents(
    Stream<LoginEvent> events,
    Stream<LoginState> Function(LoginEvent event) next,
  ) {
    final observableStream = events;
    final nonDebounceStream = observableStream.where((event) {
      return (event is! LoginEmailChanged && event is! LoginPasswordChanged);
    });
    final debounceStream = observableStream.where((event) {
      return (event is LoginEmailChanged || event is LoginPasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super
        .transformEvents(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  /// Transforms an input of [LoginEvent] to an output of [LoginState].
  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginEmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is LoginPasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is LoginWithGooglePressed) {
      yield* _mapLoginWithGooglePressedToState();
    } else if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressedToState(
        email: event.email,
        password: event.password,
      );
    } else if (event is SendPasswordResetPressed) {
      yield* _mapSendPasswordResetToState(event);
    }
  }

  Stream<LoginState> _mapEmailChangedToState(String email) async* {
    String errorString = Validators.isValidEmail(email);
    LoginState out;
    if (errorString == null) {
      out = _clearEmailError(email);
    } else {
      out = _addEmailError(errorString, email);
    }
    yield out;
  }

  LoginState _clearEmailError(email) {
    if (state is LoginCredentialsInvalid) {
      return (state as LoginCredentialsInvalid)
          .copyWith(emailError: null, email: email);
    } else if (state is LoginCredentialsInvalid) {
      return (state as LoginCredentialsValid).copyWith(email: email);
    } else {
      // LoginEmpty
      return LoginCredentialsValid(email: email);
    }
  }

  LoginState _addEmailError(emailError, email) {
    if (state is LoginCredentialsInvalid) {
      return (state as LoginCredentialsInvalid)
          .copyWith(emailError: "", email: email);
    } else {
      return LoginCredentialsInvalid(emailError: "", email: email);
    }
  }

  Stream<LoginState> _mapPasswordChangedToState(String password) async* {
    String errorString = Validators.isValidPassword(password);
    if (errorString == null) {
      yield _clearPasswordError(password);
    } else {
      yield _addPasswordError(errorString, password);
    }
  }

  LoginState _clearPasswordError(password) {
    if (state is LoginCredentialsInvalid) {
      return (state as LoginCredentialsInvalid)
          .copyWith(passwordError: null, password: password);
    } else if (state is LoginCredentialsValid) {
      return (state as LoginCredentialsValid).copyWith(password: password);
    } else {
      return LoginCredentialsValid(password: password);
    }
  }

  LoginState _addPasswordError(passwordError, password) {
    if (state is LoginCredentialsInvalid) {
      return (state as LoginCredentialsInvalid)
          .copyWith(passwordError: "", password: password);
    } else {
      return LoginCredentialsInvalid(passwordError: "", password: password);
    }
  }

  Stream<LoginState> _mapLoginWithGooglePressedToState() async* {
    authRepository.signInWithGoogle();
    yield LoginEmpty();
  }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState({
    String email,
    String password,
  }) async* {
    yield LoginLoading();
    try {
      await authRepository.signInWithCredentials(email, password);
      yield LoginSuccess();
    } on PlatformException catch (e) {
      var errorString = "Error communicating to the auToDo servers.";
      if (e.code == "ERROR_WEAK_PASSWORD") {
        errorString = "Your password must be longer than 6 characters.";
      } else if (e.code == "ERROR_INVALID_EMAIL") {
        errorString = "The email address you entered is invalid.";
      } else if (e.code == "ERROR_EMAIL_ALREADY_IN_USE") {
        errorString = "The email address you entered is already in use.";
      } else if (e.code == "ERROR_WRONG_PASSWORD") {
        errorString = "Incorrect password, please try again.";
      }
      yield LoginError(errorString);
    }
  }

  Stream<LoginState> _mapSendPasswordResetToState(event) async* {
    yield LoginLoading();
    try {
      // not doing this through the authbloc because it doesn't affect
      // the app's global authentication state (i.e. it's not possible)
      // to login or logout this way
      await authRepository.sendPasswordReset(event.email);
      yield LoginEmpty();
    } on PlatformException catch (e) {
      var errorString = "Error communicating to the auToDo servers.";
      if (e.code == 'ERROR_INVALID_EMAIL')
        errorString = "Invalid email address format";
      else if (e.code == 'ERROR_USER_NOT_FOUND')
        errorString = "Could not find an account for this email address";
      yield LoginError(errorString);
    }
  }
}
