import 'package:equatable/equatable.dart';

import 'package:autodo/repositories/repositories.dart';

abstract class DatabaseState extends Equatable {
  const DatabaseState();

  @override
  List<Object> get props => [];
}

class DbUninitialized extends DatabaseState {}

class DbLoaded extends DatabaseState {
  final DataRepository repository;
  final bool newUser;

  const DbLoaded(this.repository, [this.newUser]);

  @override
  List<Object> get props => [repository, newUser];

  @override
  String toString() =>
      'DbLoaded { repository: $repository, newUser: $newUser }';
}

class DbNotLoaded extends DatabaseState {}
