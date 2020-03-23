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

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../repositories/repositories.dart';
import '../../../validators.dart';
import '../barrel.dart';
import 'event.dart';
import 'state.dart';

/// A [Bloc] used for validating and submitting the information for the
/// [SignupScreen].
class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc({@required authRepository, this.verifyEmail = kReleaseMode})
      : assert(authRepository != null),
        _authRepository = authRepository;

  final AuthRepository _authRepository;

  /// A flag that determines whether a verification email will be sent to the
  /// user that is signing up.
  final bool verifyEmail;

  @override
  SignupState get initialState => SignupEmpty();

  /// Debounces incoming events to prevent the validator from running too often.
  @override
  Stream<SignupState> transformEvents(
    Stream<SignupEvent> events,
    Stream<SignupState> Function(SignupEvent event) next,
  ) {
    final observableStream = events;
    final nonDebounceStream = observableStream.where((event) {
      return event is! SignupEmailChanged && event is! SignupPasswordChanged;
    });
    final debounceStream = observableStream.where((event) {
      return event is SignupEmailChanged || event is SignupPasswordChanged;
    }).debounceTime(Duration(milliseconds: 300));
    return super
        .transformEvents(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  /// Takes a [SignupEvent] as an input and outputs a [SignupState].
  @override
  Stream<SignupState> mapEventToState(SignupEvent event) async* {
    if (event is SignupEmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is SignupPasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is SignupWithCredentialsPressed) {
      yield* _mapSignupWithCredentialsPressedToState(
        email: event.email,
        password: event.password,
      );
    }
  }

  Stream<SignupState> _mapEmailChangedToState(String email) async* {
    final errorString = Validators.isValidEmail(email);
    if (errorString == null) {
      yield _clearEmailError();
    } else {
      yield _addEmailError(errorString);
    }
  }

  SignupState _clearEmailError() {
    if (state is SignupCredentialsInvalid) {
      return (state as SignupCredentialsInvalid).copyWith(emailError: null);
    } else {
      return SignupCredentialsValid();
    }
  }

  SignupState _addEmailError(emailError) {
    if (state is SignupCredentialsInvalid) {
      return (state as SignupCredentialsInvalid).copyWith(emailError: '');
    } else {
      return SignupCredentialsInvalid(emailError: '');
    }
  }

  Stream<SignupState> _mapPasswordChangedToState(String password) async* {
    final errorString = Validators.isValidPassword(password);
    if (errorString == null) {
      yield _clearPasswordError();
    } else {
      yield _addPasswordError(errorString);
    }
  }

  SignupState _clearPasswordError() {
    if (state is SignupCredentialsInvalid) {
      return (state as SignupCredentialsInvalid).copyWith(emailError: null);
    } else {
      return SignupCredentialsValid();
    }
  }

  SignupState _addPasswordError(passwordError) {
    if (state is SignupCredentialsInvalid) {
      return (state as SignupCredentialsInvalid).copyWith(passwordError: '');
    } else {
      return SignupCredentialsInvalid(passwordError: '');
    }
  }

  Future<void> _checkIfUserIsVerified(user) async {
    bool verified = user.isEmailVerified;
    while (!verified) {
      await Future.delayed(const Duration(milliseconds: 100));
      final cur = await _authRepository.getCurrentUser();
      await cur.reload();
      verified = cur.isEmailVerified;
    }
  }

  Stream<SignupState> _mapSignupWithCredentialsPressedToState({
    String email,
    String password,
  }) async* {
    yield SignupLoading();
    try {
      if (verifyEmail) {
        final user =
            await _authRepository.signUpWithVerification(email, password);
        yield VerificationSent();
        await _checkIfUserIsVerified(user);
        yield UserVerified();
      } else {
        await _authRepository.signUp(email, password);
        yield SignupSuccess();
      }
    } on PlatformException catch (e) {
      var errorString = 'Error communicating to the auToDo servers.';
      if (e.code == 'ERROR_WEAK_PASSWORD') {
        errorString = 'Your password must be longer than 6 characters.';
      } else if (e.code == 'ERROR_INVALID_EMAIL') {
        errorString = 'The email address you entered is invalid.';
      } else if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
        errorString = 'The email address you entered is already in use.';
      } else if (e.code == 'ERROR_WRONG_PASSWORD') {
        errorString = 'Incorrect password, please try again.';
      }
      yield SignupError(errorString);
    }
  }
}
