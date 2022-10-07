import 'dart:io';

abstract class StorageRepository {
  Future<void> uploadFile(File file, String uid);
  Future<String> getUserProfileImage(String uid);
}
