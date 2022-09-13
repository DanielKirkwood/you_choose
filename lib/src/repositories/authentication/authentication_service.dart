import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:you_choose/src/models/models.dart';
import 'package:you_choose/src/util/logger/logger.dart';

class AuthenticationService {
  var logger = getLogger('AuthService');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get the currently logged in user
  Stream<UserModel> retrieveCurrentUser() {
    logger.d('retrieveCurrentUser');
    return _auth.authStateChanges().map((User? user) {
      if (user != null) {
        return UserModel(uid: user.uid, email: user.email);
      } else {
        return UserModel(uid: 'uid');
      }
    });
  }

  // sign given user up using email/password
  Future<UserCredential?> signUp(UserModel user) async {
    try {
      logger.d('signUp');

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: user.email!, password: user.password!);

      logger.d('signUp - userCredential = ${userCredential.user!.email}');

      await verifyEmail();

      return userCredential;
    } catch (error) {
      AuthResultStatus status = handleException(error);
      String errorMessage = generateExceptionMessage(status);
      logger.e(errorMessage);
    }
  }

  // sign given user in using email/password
  Future<UserCredential?> signIn(UserModel user) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: user.email!, password: user.password!);

      if (userCredential.user != null) {
        logger.i('signIn user ${userCredential.user!.uid}');
      }

      return userCredential;
    } catch (error) {
      AuthResultStatus status = handleException(error);
      String errorMessage = generateExceptionMessage(status);
      logger.e(errorMessage);
    }
  }

  // send email verification email to user
  Future<void> verifyEmail() async {
    User? user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      return await user.sendEmailVerification();
    }
  }

  // sign user out
  Future<void> signOut() async {
    if (_auth.currentUser != null) {
      String? uid = _auth.currentUser?.uid;
      logger.i('signOut user $uid');
      await _auth.signOut();
    } else {
      logger.w('signOut failed as no user logged in');
    }
  }

  bool isValidEmail(String email) {
    return RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(email);
  }

  static handleException(e) {
    debugPrint(e.code);
    AuthResultStatus status;
    switch (e.code) {
      case "invalid-email":
        status = AuthResultStatus.invalidEmail;
        break;
      case "wrong-password":
        status = AuthResultStatus.wrongPassword;
        break;
      case "user-not-found":
        status = AuthResultStatus.userNotFound;
        break;
      case "user-disabled":
        status = AuthResultStatus.userDisabled;
        break;
      case "too-many-requests":
        status = AuthResultStatus.tooManyRequests;
        break;
      case "operation-not-allowed":
        status = AuthResultStatus.operationNotAllowed;
        break;
      case "email-already-in-use":
        status = AuthResultStatus.emailAlreadyExists;
        break;
      case "username-already-exists":
        status = AuthResultStatus.usernameAlreadyExists;
        break;
      default:
        status = AuthResultStatus.undefined;
    }
    return status;
  }

  static generateExceptionMessage(exceptionCode) {
    String errorMessage;
    switch (exceptionCode) {
      case AuthResultStatus.invalidEmail:
        errorMessage = "Your email address appears to be malformed.";
        break;
      case AuthResultStatus.wrongPassword:
        errorMessage = "Your password is incorrect.";
        break;
      case AuthResultStatus.userNotFound:
        errorMessage = "User with this email doesn't exist.";
        break;
      case AuthResultStatus.userDisabled:
        errorMessage = "User with this email has been disabled.";
        break;
      case AuthResultStatus.tooManyRequests:
        errorMessage = "Too many requests. Try again later.";
        break;
      case AuthResultStatus.operationNotAllowed:
        errorMessage = "Signing in with Email and Password is not enabled.";
        break;
      case AuthResultStatus.emailAlreadyExists:
        errorMessage =
            "The email has already been registered. Please login or reset your password.";
        break;
      case AuthResultStatus.usernameAlreadyExists:
        errorMessage = "The username has been taken. Please try another.";
        break;
      default:
        errorMessage = "An undefined Error happened.";
    }

    return errorMessage;
  }
}
