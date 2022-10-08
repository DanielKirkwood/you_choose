import 'package:firebase_auth/firebase_auth.dart';
import 'package:you_choose/src/models/models.dart';

abstract class AuthenticationRepository {
  Stream<UserModel> getCurrentUser();
  Future<UserCredential> signUp(
      {required String email, required String password});
  Future<UserCredential> signIn(
      {required String email, required String password});
  Future<void> signOut();
  Future<UserModel> getUserData({required String email});
  Future<void> changeUserPassword(String newPassword);
}
