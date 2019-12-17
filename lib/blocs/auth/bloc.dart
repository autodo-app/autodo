import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter/services.dart';
import 'package:autodo/repositories/auth_repository.dart';

import 'event.dart';
import 'state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthRepository _userRepository;

  AuthenticationBloc({@required AuthRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    } else if (event is DeletedUser) {
      yield* _mapDeletedUserToState();
    } else if (event is SignInWithGoogle) {
      yield* _mapSignInWithGoogleToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      final isSignedIn = await _userRepository.isSignedIn();
      if (isSignedIn) {
        final name = await _userRepository.getUserEmail();
        String uuid = await _userRepository.getUserId();
        yield Authenticated(name, uuid);
      } else {
        yield Unauthenticated();
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    var _email = await _userRepository.getUserEmail();
    var _uuid = await _userRepository.getUserId();
    yield Authenticated(_email, _uuid);
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    _userRepository.signOut();
  }

  Stream<AuthenticationState> _mapDeletedUserToState() async* {
    await _userRepository.deleteCurrentUser();
    yield Unauthenticated();
  }

  Stream<AuthenticationState> _mapSignInWithGoogleToState() async* {
    var user = await _userRepository.signInWithGoogle();
    yield Authenticated(user.email, user.uid);
  }
}


