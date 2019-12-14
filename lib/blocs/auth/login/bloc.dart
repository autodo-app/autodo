import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../barrel.dart';
import '../validators.dart';
import 'event.dart';
import 'state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationBloc _authBloc;
  StreamSubscription _authSubscription;

  LoginBloc({@required authBloc}) : assert(authBloc != null), _authBloc = authBloc;

  @override
  LoginState get initialState => LoginState.empty();

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
    }
  }

  Stream<LoginState> _mapLoadLoginToState() async* {
    _authSubscription?.cancel();
    _authSubscription = _authBloc.listen((state) {
      if (state is Authenticated) {
        add(LoginSuccess());
      } else if (state is Unauthenticated) {
        add(LoginFailure(state.error));
      }
    });
  }

  Stream<LoginState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<LoginState> _mapPasswordChangedToState(String password) async* {
    yield state.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<LoginState> _mapLoginWithGooglePressedToState() async* {
    _authBloc.add(SignInWithGoogle());
  }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState({
    String email,
    String password,
  }) async* {
    yield LoginState.loading();
    _authBloc.add(Login(email, password));
  }
}