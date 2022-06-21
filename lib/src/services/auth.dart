import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:you_choose/src/screens/home_screen.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // handle logged in user state
  handleAuthState() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return const HomeScreen();
          } else {
            return const Text('Logged out');
          }
        });
  }

  // sign user in with email and password
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = credential.user;
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }

      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // sign user out
  void signOut() async {
    if (_auth.currentUser != null) {
      String? uid = _auth.currentUser?.uid;
      print('signing out $uid');
      await _auth.signOut();
      return;
    }
    print('no user to sign out');
    return;
  }

  // create user with email and password
  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = credential.user;
      if (user != null) {
        print('created user: ${user.uid}');
      }
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('Email already in use.');
      } else if (e.code == 'weak-password') {
        print('Password is too weak.');
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
