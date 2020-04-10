import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../../flavor.dart';
import 'storage_repository.dart';

class FirebaseStorageRepository extends StorageRepository {
  FirebaseStorageRepository({firebaseStorageInstance, @required this.uuid}) :
    firebaseStorageInstance = firebaseStorageInstance ?? FirebaseStorage.instance;

  final String uuid;
  final FirebaseStorage firebaseStorageInstance;

  @override
  Future<String> getDownloadUrl(String assetName) async {
    final resourceUrl = joinAll(['${kFlavor.firebaseStorageUri}', uuid, assetName]);
    final ref = await firebaseStorageInstance.getReferenceFromUrl(resourceUrl);
    final downloadUrl = await ref.getDownloadURL();
    return downloadUrl;
  }

  @override
  Future<void> storeAsset(File asset) async {
    // TODO: use dart:image to resize the photo
    // not sure what size we'll want though, thinking it should be the width
    // of largest smartphone and a 16:9 ratio? not sure
    final resourceUrl = join(uuid, asset.path);
    final ref = firebaseStorageInstance.ref().child(resourceUrl);
    final uploadTask = ref.putFile(asset);
    await uploadTask.onComplete;
  }

  @override
  List<Object> get props => [];
}