import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'storage_repository.dart';

class LocalStorageRepository extends StorageRepository {
  LocalStorageRepository({this.pathProvider = getApplicationDocumentsDirectory});

  final FutureOr<Directory> Function() pathProvider;

  Future<String> getDownloadUrl(String assetName) async {
    final path = await pathProvider();
    return join(path.path, assetName);
  }

  @override
  List<Object> get props => [];
}