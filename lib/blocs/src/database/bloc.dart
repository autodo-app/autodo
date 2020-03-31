import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../repositories/repositories.dart';
import '../../../repositories/src/sembast_data_repository.dart';
import '../auth/barrel.dart';
import 'event.dart';
import 'state.dart';

class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
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

  final Firestore _firestoreInstance;

  final AuthenticationBloc _authenticationBloc;

  StreamSubscription _authSubscription;

  Future<Directory> Function() pathProvider;

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

  Stream<DatabaseState> _mapUserLoggedInToState(UserLoggedIn event) async* {
    final repository = await FirebaseDataRepository.open(
        firestoreInstance: _firestoreInstance,
        uuid: event.uuid,
        newUser: event.newUser);
    yield DbLoaded(repository, event.newUser);
  }

  Stream<DatabaseState> _mapUserLoggedOutToState(UserLoggedOut event) async* {
    if (state is DbLoaded) {
      final repo = (state as DbLoaded).repository;
      if (repo is SembastDataRepository) {
        await repo.close();
        // ToDo: We should leave the DB on disk if they logged out by mistake
        await SembastDataRepository.deleteDb(repo.db.path);
      }
    }
    yield DbNotLoaded();
  }

  Stream<DatabaseState> _mapTrialLoginToState(TrialLogin event) async* {
    if (state is DbLoaded) {
      // Close the old database, open the new one
      final repo = (state as DbLoaded).repository;
      if (repo is SembastDataRepository) {
        await repo.close();
      }
    }

    var newUser = event.newUser;

    if (!newUser) {
      // Check if the DB already exists
      final file = File(
          await SembastDataRepository.getFullPath(pathProvider: pathProvider));
      if (await file.exists()) {
        newUser = false;
      }
    }

    final repo = await SembastDataRepository.open(pathProvider: pathProvider);
    yield DbLoaded(repo, newUser);
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
