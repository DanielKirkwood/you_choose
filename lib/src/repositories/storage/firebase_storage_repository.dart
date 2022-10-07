import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:you_choose/src/repositories/repositories.dart';
import 'package:you_choose/src/util/logger/logger.dart';

class FirebaseStorageRepository implements StorageRepository {
  final FirebaseStorage _storage;

  FirebaseStorageRepository({FirebaseStorage? firebaseStorage})
      : _storage = firebaseStorage ?? FirebaseStorage.instance;

  var logger = getLogger('FirebaseStorageRepository');

  @override
  Future<String> getUserProfileImage(String uid) async {
    return await _storage.ref().child("user/profile/$uid").getDownloadURL();
  }

  @override
  Future<void> uploadFile(File file, String uid) async {
    var storageRef = _storage.ref().child('user/profile/$uid');

    try {
      await storageRef.putFile(file);

      return;
    } catch (e) {
      logger.w(e.toString());
      return;
    }
  }
}
