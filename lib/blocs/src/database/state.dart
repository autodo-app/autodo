import 'package:equatable/equatable.dart';

import '../../../repositories/repositories.dart';

abstract class DatabaseState extends Equatable {
  const DatabaseState();

  @override
  List<Object> get props => [];
}

class DbUninitialized extends DatabaseState {}

class DbLoaded extends DatabaseState {
  const DbLoaded(this.repository, [this.newUser]);

  final DataRepository repository;

  final bool newUser;

  @override
  List<Object> get props => [repository, newUser];

  @override
  String toString() =>
      'DbLoaded { repository: $repository, newUser: $newUser }';
}

class DbNotLoaded extends DatabaseState {}
