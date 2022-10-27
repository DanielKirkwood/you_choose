import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

/// {@template storage_repository}
/// Flutter package which manages the storage domain.
/// {@endtemplate}
class StorageRepository {
  /// {@macro friend_repository}
  StorageRepository({
    FirebaseStorage? storage,
  }) : _storage = storage ?? FirebaseStorage.instance;

  final FirebaseStorage _storage;

  /// The user selects a file, and the task is added to the list.
  Future<UploadTask> uploadFile({
    required XFile file,
    required String username,
  }) async {
    UploadTask uploadTask;

    // Create a Reference to the file
    final ref = _storage.ref().child('users/$username.jpg');

    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': file.path},
    );

    uploadTask = ref.putFile(File(file.path), metadata);

    return Future.value(uploadTask);
  }

  /// Get the given users image downloadURL, if it doesn't exist the default image
  /// is given instead.
  Future<String> getProfileImage({required String username}) async {
    try {
      final storageRef = _storage.ref().child('users/$username.jpg');
      return storageRef.getDownloadURL();
    } catch (_) {
      final storageRef =
          _storage.ref().child('users/user-profile-default_profile.jpg');
      return storageRef.getDownloadURL();
    }
  }
}
