import 'package:firebase_auth/firebase_auth.dart';
import 'package:you_choose/src/data/data.dart';

abstract class AuthenticationRepository {
  Stream<UserModel> get user;
  UserModel get currentUser;
  void signUp({required String email, required String password});
  void logInWithEmailAndPassword({
    required String email,
    required String password,
  });
  void logOut();
}
