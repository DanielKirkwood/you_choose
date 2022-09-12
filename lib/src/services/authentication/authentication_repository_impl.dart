import 'package:firebase_auth/firebase_auth.dart';
import 'package:you_choose/src/models/user.dart';
import 'package:you_choose/src/services/authentication/authentication_service.dart';
import 'package:you_choose/src/services/database/database_service.dart';
import 'package:you_choose/src/util/logger/logger.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  AuthenticationService authService = AuthenticationService();
  DatabaseService dbService = DatabaseService();
  var logger = getLogger('AuthenticationRepositoryImpl');

  @override
  Stream<UserModel> getCurrentUser() {
    logger.i('getCurrentUser');

    return authService.retrieveCurrentUser();
  }

  @override
  Future<UserCredential?> signUp(UserModel user) {
    try {
      logger.i('signUp user ${user.toString()}');
      return authService.signUp(user);
    } on FirebaseAuthException catch (e) {
      logger.e(e.message);
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  @override
  Future<UserCredential?> signIn(UserModel user) {
    try {
      logger.i('signIn user ${user.toString()}');
      return authService.signIn(user);
    } on FirebaseAuthException catch (e) {
      logger.e(e.message);
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  @override
  Future<void> signOut() {
    logger.i('logging out');
    return authService.signOut();
  }

  @override
  Future<String?> retrieveUserName(UserModel user) {
    logger.i('retrieveUserName ${user.toString()}');

    return dbService.retrieveUserName(user);
  }
}

abstract class AuthenticationRepository {
  Stream<UserModel> getCurrentUser();
  Future<UserCredential?> signUp(UserModel user);
  Future<UserCredential?> signIn(UserModel user);
  Future<void> signOut();
  Future<String?> retrieveUserName(UserModel user);
}
