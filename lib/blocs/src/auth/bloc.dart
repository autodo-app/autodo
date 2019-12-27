import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:autodo/repositories/repositories.dart';

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
      yield* _mapAppStartedToState(event);
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    } else if (event is DeletedUser) {
      yield* _mapDeletedUserToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState(event) async* {
    try {
      final repo = FirebaseAuthRepository();
      if ((event as AppStarted).integrationTest ?? false) {
        await repo.signOut()
          .then((_) {
            try {
              repo.signInWithCredentials('integration-test@autodo.app', '123456')
                .then((_) => repo.deleteCurrentUser());
            } catch (e) {
              print(e);
            }
          });
      }
      final isSignedIn = await _userRepository.isSignedIn();
      if (isSignedIn) {
        final name = await _userRepository.getUserEmail();
        String uuid = await _userRepository.getUserId();
        yield Authenticated(name, uuid);
      } else {
        yield Unauthenticated();
      }
    } catch (e) {
      print(e);
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
    yield Unauthenticated();
    await _userRepository.deleteCurrentUser();
  }
}


