import 'dart:io';

abstract class StorageRepository {
  Future<String> uploadFile(File file, String uid);
  Future<String> getUserProfileImage(String uid);
}
