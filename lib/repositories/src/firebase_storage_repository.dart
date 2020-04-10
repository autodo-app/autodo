import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../../flavor.dart';
import 'storage_repository.dart';

class FirebaseStorageRepository extends StorageRepository {
  FirebaseStorageRepository({this.firebaseStorageInstance, @required this.uuid});

  final String uuid;
  final FirebaseStorage firebaseStorageInstance;

  @override
  Future<String> getDownloadUrl(String assetName) async {
    final resourceUrl = joinAll(['${kFlavor.firebaseStorageUri}', uuid, assetName]);
    final ref = await FirebaseStorage.instance.getReferenceFromUrl(resourceUrl);
    final downloadUrl = await ref.getDownloadURL();
    return downloadUrl;
  }

  @override
  List<Object> get props => [];
}