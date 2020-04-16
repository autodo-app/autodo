import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'storage_repository.dart';

class LocalStorageRepository extends StorageRepository {
  LocalStorageRepository(
      {this.pathProvider = getApplicationDocumentsDirectory});

  final FutureOr<Directory> Function() pathProvider;

  @override
  Future<String> getDownloadUrl(String assetName) async {
    final path = await pathProvider();
    return join(path.path, assetName);
  }

  /// just copying the file to the app docs directory
  @override
  Future<void> storeAsset(File asset) async {
    final path = await pathProvider();
    final newPath = join(path.path, basename(asset.path));
    await asset.copy(newPath);
  }

  @override
  List<Object> get props => [];
}
