import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:you_choose/src/models/auth_result_status.dart';
import 'package:you_choose/src/models/user.dart';

import 'package:you_choose/src/screens/home_screen.dart';
import 'package:you_choose/src/screens/login_screen.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  AuthResultStatus _status = AuthResultStatus.undefined;

  // handle logged in user state
  handleAuthState() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasData) {
            return const HomeScreen();
          } else {
            return const LoginScreen();
          }
        });
  }

  // sign user in with email and password
  Future<AuthResultStatus> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      if (!isValidEmail(email)) {
        _status = AuthResultStatus.invalidEmail;
      }
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (credential.user != null) {
        _status = AuthResultStatus.successful;
      } else {
        _status = AuthResultStatus.undefined;
      }
    } catch (e) {
      debugPrint('Exception @login: $e');
      _status = handleException(e);
    }
    return _status;
  }


  Future<AppUser?> getCurrentUser()  async {
    if (_auth.currentUser != null) {
      String uid = _auth.currentUser!.uid;
      final ref = _db
          .collection('users')
          .where('uid', isEqualTo: uid)
          .limit(1)
          .withConverter(
          fromFirestore: AppUser.fromFirestore,
          toFirestore: (AppUser user, _) => user.toFirestore());

      final test = await ref.get();

      AppUser user = test.docs.first.data();

      return user;
    }
    return null;
  }

  // sign user out
  void signOut() async {
    if (_auth.currentUser != null) {
      String? uid = _auth.currentUser?.uid;
      debugPrint('signing out $uid');
      await _auth.signOut();
      return;
    }
    debugPrint('no user to sign out');
    return;
  }

  // create user with email and password
  Future<AuthResultStatus> createUser(
      {required String email,
      required String username,
      required String password}) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc =
          await _db.collection('users').doc(username).get();

      if (doc.exists) {
        debugPrint('a user with username: $username already exists');
        _status = handleException('username-already-exists');

        return _status;
      }

      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = credential.user;
      if (user != null) {
        _status = AuthResultStatus.successful;

        _db.collection('users').doc(username).set({
          'uid': user.uid,
          'name': user.displayName,
          'username': username,
          'email': user.email
        }).onError((error, stackTrace) {
          debugPrint('Exception @createAccount: $error');
          _status = handleException(error);
        });
      }
    } catch (e) {
      debugPrint('Exception @createAccount: $e');
      _status = handleException(e);
    }

    return _status;
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
