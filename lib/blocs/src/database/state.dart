import 'package:equatable/equatable.dart';

import '../../../repositories/repositories.dart';

abstract class DatabaseState extends Equatable {
  const DatabaseState();

  @override
  List<Object> get props => [];
}

class DbUninitialized extends DatabaseState {}

class DbLoaded extends DatabaseState {
  const DbLoaded(this.dataRepo, {this.storageRepo});

  final DataRepository dataRepo;

  final StorageRepository storageRepo;

  @override
  List<Object> get props => [dataRepo, FirebaseStorageRepository];

  @override
  String toString() =>
      'DbLoaded { dataRepo: $dataRepo, storageRepo: $storageRepo }';
}

class DbNotLoaded extends DatabaseState {}
