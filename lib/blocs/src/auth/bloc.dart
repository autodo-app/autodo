import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:autodo/repositories/repositories.dart';

import 'event.dart';
import 'state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthRepository _userRepository;

  AuthenticationBloc({@required AuthRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository {
    _userRepository.stream?.listen((user) {
      if (user != null && (!(state is Authenticated) || 
         (state as Authenticated).uuid != user.uid )) {
        // sign in or sign up
        if (user.metadata.creationTime == user.metadata.lastSignInTime) {
          add(SignedUp());
        } else {
          add(LoggedIn());
        }
      }
    });
  }

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
    } else if (event is LogOut) {
      yield* _mapLogOutToState();
    } else if (event is DeletedUser) {
      yield* _mapDeletedUserToState();
    } else if (event is SignedUp) {
      yield* _mapSignedUpToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState(event) async* {
    try {
      final repo = FirebaseAuthRepository();
      if ((event as AppStarted).integrationTest ?? false) {
        await repo.signOut().then((_) {
          try {
            repo
                .signInWithCredentials('integration-test@autodo.app', '123456')
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
        yield Authenticated(name, uuid, false);
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
    yield Authenticated(_email, _uuid, false);
  }

  Stream<AuthenticationState> _mapSignedUpToState() async* {
    var _email = await _userRepository.getUserEmail();
    var _uuid = await _userRepository.getUserId();
    yield Authenticated(_email, _uuid, true);
  }

  Stream<AuthenticationState> _mapLogOutToState() async* {
    yield Unauthenticated();
    _userRepository.signOut();
  }

  Stream<AuthenticationState> _mapDeletedUserToState() async* {
    yield Unauthenticated();
    await _userRepository.deleteCurrentUser();
  }
}
