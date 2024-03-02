import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:paypie_flutter/services/auth_service.dart';

class StorageService {
  static final StorageService _singleton = StorageService._internal();
  factory StorageService() {
    return _singleton;
  }
  StorageService._internal();

  static StorageService get instance => StorageService();
  FirebaseStorage get _storage => FirebaseStorage.instance;

  Future<String> uploadProfileImageToStorage({
    required String userId,
    required Uint8List file,
  }) async {
    Reference ref = _storage
        .ref()
        .child("profiles")
        .child(userId)
        .child(AuthService.instance.currentUser!.uid);

    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
