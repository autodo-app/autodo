import 'dart:async';

import 'package:autodo/repositories/auth_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../barrel.dart';
import '../validators.dart';
import 'event.dart';
import 'state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  AuthRepository _authRepository;
  final AuthenticationBloc _authBloc;
  StreamSubscription _authSubscription;

  LoginBloc({@required authBloc}) : assert(authBloc != null), _authBloc = authBloc;

  @override
  LoginState get initialState => LoginEmpty();

  @override
  Stream<LoginState> transformEvents(
    Stream<LoginEvent> events,
    Stream<LoginState> Function(LoginEvent event) next,
  ) {
    final observableStream = events as Observable<LoginEvent>;
    final nonDebounceStream = observableStream.where((event) {
      return (event is! LoginEmailChanged && event is! LoginPasswordChanged);
    });
    final debounceStream = observableStream.where((event) {
      return (event is LoginEmailChanged || event is LoginPasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), next);
  }

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
    String errorString;
    if (email.isEmpty)
      errorString = 'Email can\'t be empty';
    else if (!email.contains('@') || !email.contains('.'))
      errorString = 'Invalid email address';
    
    if (errorString == null) {
      yield _clearEmailError();
    } else {
      yield _addEmailError(errorString);
    }
  }

  LoginState _clearEmailError() {
    if (state is LoginCredentialsInvalid) {
      return (state as LoginCredentialsInvalid).copyWith(emailError: null);
    } else {
      return LoginCredentialsValid();
    }
  }

  LoginState _addEmailError(emailError) {
    if (state is LoginCredentialsInvalid) {
      return (state as LoginCredentialsInvalid).copyWith(emailError: "");
    } else {
      return LoginCredentialsInvalid(emailError: "");
    }
  }

  Stream<LoginState> _mapPasswordChangedToState(String password) async* {
    String errorString;
    if (password.isEmpty)
      errorString = 'Password can\'t be empty';
    else if (password.length < 6)
      errorString =  'Password must be longer than 6 characters';
    
    if (errorString == null) {
      yield _clearPasswordError();
    } else {
      yield _addPasswordError(errorString);
    }
  }

  LoginState _clearPasswordError() {
    if (state is LoginCredentialsInvalid) {
      return (state as LoginCredentialsInvalid).copyWith(emailError: null);
    } else {
      return LoginCredentialsValid();
    }
  }

  LoginState _addPasswordError(passwordError) {
    if (state is LoginCredentialsInvalid) {
      return (state as LoginCredentialsInvalid).copyWith(passwordError: "");
    } else {
      return LoginCredentialsInvalid(passwordError: "");
    }
  }

  Stream<LoginState> _mapLoginWithGooglePressedToState() async* {
    _authBloc.add(SignInWithGoogle());
  }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState({
    String email,
    String password,
  }) async* {
    yield LoginLoading();
    try {
      await _authRepository.signInWithCredentials(email, password);
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
      await _authRepository.sendPasswordReset(event.email);
    } on PlatformException catch (e) {
      var errorString = "Error communicating to the auToDo servers.";
      if (e.code == 'ERROR_INVALID_EMAIL')
        errorString = "Invalid email address format";
      else if (e.code == 'ERROR_USER_NOT_FOUND')
        errorString = "Could not find an account for this email address";
      yield LoginError(errorString);
    }
    yield LoginEmpty();
  }
}