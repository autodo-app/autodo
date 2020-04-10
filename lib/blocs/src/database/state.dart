import 'package:equatable/equatable.dart';

import '../../../repositories/repositories.dart';

abstract class DatabaseState extends Equatable {
  const DatabaseState();

  @override
  List<Object> get props => [];
}

class DbUninitialized extends DatabaseState {}

class DbLoaded extends DatabaseState {
  const DbLoaded(this.dataRepo, {this.storageRepo, this.newUser});

  final DataRepository dataRepo;

  final StorageRepository storageRepo;

  final bool newUser;

  @override
  List<Object> get props => [dataRepo, storageRepo, newUser];

  @override
  String toString() =>
      'DbLoaded { dataRepo: $dataRepo, storageRepo: $storageRepo, newUser: $newUser }';
}

class DbNotLoaded extends DatabaseState {}
