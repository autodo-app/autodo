import 'dart:async';
import 'dart:io';

import 'package:autodo/repositories/src/sembast_data_repository.dart';
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
  Future<Directory> Function() pathProvider;

  DatabaseBloc(
      {firestoreInstance, @required authenticationBloc, this.pathProvider})
      : assert(authenticationBloc != null),
        _authenticationBloc = authenticationBloc,
        _firestoreInstance = firestoreInstance ?? Firestore.instance {
    _authSubscription = _authenticationBloc.listen((authState) {
      if (authState is RemoteAuthenticated) {
        add(UserLoggedIn(authState.uuid, authState.newUser));
      } else if (((state is DbNotLoaded) || (state is DbUninitialized)) &&
          authState is LocalAuthenticated) {
        add(TrialLogin(authState.newUser));
      } else if (authState is Unauthenticated) {
        add(UserLoggedOut());
      }
    });
  }

  @override
  DatabaseState get initialState => DbUninitialized();

  @override
  Stream<DatabaseState> mapEventToState(DatabaseEvent event) async* {
    if (event is UserLoggedIn) {
      yield* _mapUserLoggedInToState(event);
    } else if (event is UserLoggedOut) {
      yield* _mapUserLoggedOutToState(event);
    } else if (event is TrialLogin) {
      yield* _mapTrialLoginToState(event);
    }
  }

  Stream<DatabaseState> _mapUserLoggedInToState(event) async* {
    FirebaseDataRepository repository = FirebaseDataRepository(
      firestoreInstance: _firestoreInstance,
      uuid: event.uuid,
    );
    yield DbLoaded(repository, event.newUser);
  }

  Stream<DatabaseState> _mapUserLoggedOutToState(event) async* {
    if (state is DbLoaded &&
        (state as DbLoaded).repository is SembastDataRepository) {
      print('deleting db');
      await ((state as DbLoaded).repository as SembastDataRepository)
          .deleteDb();
    }
    yield DbNotLoaded();
  }

  Stream<DatabaseState> _mapTrialLoginToState(event) async* {
    if (state is DbLoaded) {
      print('ignoring outdated trial login event');
      return;
    }
    final repo = await SembastDataRepository(
        createDb: event.newUser, pathProvider: pathProvider);
    await repo.load();
    yield DbLoaded(repo, event.newUser);
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
