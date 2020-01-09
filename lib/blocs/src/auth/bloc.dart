import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:autodo/repositories/repositories.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'event.dart';
import 'state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthRepository _userRepository;
  static const String trialUserKey = 'trialUserLoggedIn';

  AuthenticationBloc({@required AuthRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository {
    _userRepository.stream?.listen((user) {
      if (user != null &&
          (!(state is RemoteAuthenticated) ||
              (state as RemoteAuthenticated).uuid != user.uid)) {
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
    } else if (event is TrialUserSignedUp) {
      yield* _mapTrialUserSignedUpToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState(event) async* {
    try {
      final repo = FirebaseAuthRepository();
      if ((event as AppStarted).integrationTest ?? false) {
        await repo.signOut();
        await repo.signInWithCredentials(
            'integration-test@autodo.app', '123456');
        await repo.deleteCurrentUser();
      }
      final prefs = await SharedPreferences.getInstance();

      final isSignedIn = await _userRepository.isSignedIn();
      if (isSignedIn) {
        final name = await _userRepository.getUserEmail();
        String uuid = await _userRepository.getUserId();
        yield RemoteAuthenticated(name, uuid, false);
      } else if (prefs.getBool(trialUserKey)) {
        yield LocalAuthenticated(false);
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
    yield RemoteAuthenticated(_email, _uuid, false);

    // make sure that any past trial users are no longer logged in
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(trialUserKey, true);
  }

  Stream<AuthenticationState> _mapSignedUpToState() async* {
    var _email = await _userRepository.getUserEmail();
    var _uuid = await _userRepository.getUserId();
    yield RemoteAuthenticated(_email, _uuid, true);

    // make sure that any past trial users are no longer logged in
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(trialUserKey, true);
  }

  Stream<AuthenticationState> _mapLogOutToState() async* {
    yield Unauthenticated();
    _userRepository.signOut();
  }

  Stream<AuthenticationState> _mapDeletedUserToState() async* {
    yield Unauthenticated();
    await _userRepository.deleteCurrentUser();
  }

  Stream<AuthenticationState> _mapTrialUserSignedUpToState() async* {
    yield LocalAuthenticated(true);
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(trialUserKey, true);
  }
}
