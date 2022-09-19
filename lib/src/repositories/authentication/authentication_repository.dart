import 'package:firebase_auth/firebase_auth.dart';
import 'package:you_choose/src/models/models.dart';

abstract class AuthenticationRepository {
  Stream<UserModel> getCurrentUser();
  Future<UserCredential?> signUp(UserModel user);
  Future<UserCredential?> signIn(UserModel user);
  Future<void> signOut();
  Future<UserModel?> getUserData(UserModel user);
}
