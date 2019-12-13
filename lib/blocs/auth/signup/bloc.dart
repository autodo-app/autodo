import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'package:autodo/repositories/auth_repository.dart';
import '../validators.dart';
import 'event.dart';
import 'state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthRepository _userRepository;

  SignupBloc({@required AuthRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  SignupState get initialState => SignupState.empty();

  @override
  Stream<SignupState> transformEvents(
    Stream<SignupEvent> events,
    Stream<SignupState> Function(SignupEvent event) next,
  ) {
    final observableStream = events as Observable<SignupEvent>;
    final nonDebounceStream = observableStream.where((event) {
      return (event is! SignupEmailChanged && event is! SignupPasswordChanged);
    });
    final debounceStream = observableStream.where((event) {
      return (event is SignupEmailChanged || event is SignupPasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  @override
  Stream<SignupState> mapEventToState(
    SignupEvent event,
  ) async* {
    if (event is SignupEmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is SignupPasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is SignupSubmitted) {
      yield* _mapFormSubmittedToState(event.email, event.password);
    }
  }

  Stream<SignupState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<SignupState> _mapPasswordChangedToState(String password) async* {
    yield state.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<SignupState> _mapFormSubmittedToState(
    String email,
    String password,
  ) async* {
    yield SignupState.loading();
    try {
      await _userRepository.signUp(email, password);
      yield SignupState.success();
    } catch (_) {
      yield SignupState.failure();
    }
  }
}
