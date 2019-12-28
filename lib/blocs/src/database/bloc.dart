import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:autodo/repositories/repositories.dart';
import 'event.dart';
import 'state.dart';
import '../auth/barrel.dart';

class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
  final Firestore _firestoreInstance;
  AuthenticationBloc _authenticationBloc;
  StreamSubscription _authSubscription;

  DatabaseBloc({firestoreInstance, @required authenticationBloc})
      : assert(authenticationBloc != null),
        _authenticationBloc = authenticationBloc,
        _firestoreInstance = firestoreInstance ?? Firestore.instance;

  @override
  DatabaseState get initialState => DbUninitialized();

  @override
  Stream<DatabaseState> mapEventToState(DatabaseEvent event) async* {
    if (event is LoadDatabase) {
      yield* _mapLoadDatabaseToState(event);
    } else if (event is UserLoggedIn) {
      yield* _mapUserLoggedInToState(event);
    } else if (event is UserLoggedOut) {
      yield* _mapUserLoggedOutToState(event);
    }
  }

  Stream<DatabaseState> _mapLoadDatabaseToState(event) async* {
    _authSubscription?.cancel();
    _authSubscription = _authenticationBloc.listen((state) {
      if (state is Authenticated) {
        add(UserLoggedIn(state.uuid));
      }
    });
  }

  Stream<DatabaseState> _mapUserLoggedInToState(event) async* {
    FirebaseDataRepository repository = FirebaseDataRepository(
      firestoreInstance: _firestoreInstance,
      uuid: event.uuid,
    );
    yield DbLoaded(repository);
  }

  Stream<DatabaseState> _mapUserLoggedOutToState(event) async* {
    yield DbNotLoaded();
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
