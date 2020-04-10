import 'package:equatable/equatable.dart';

abstract class StorageRepository extends Equatable {
  Future<String> getDownloadUrl(String assetName);
}