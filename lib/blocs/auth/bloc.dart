import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
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
    String email = await _userRepository.getUserEmail();
    String uuid = await _userRepository.getUserId();
    yield Authenticated(email, uuid);
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    _userRepository.signOut();
  }
}


