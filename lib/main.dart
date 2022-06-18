import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:you_choose/src/app.dart';

import 'firebase_options.dart';

const bool _isProduction = bool.fromEnvironment('dart.vm.product');

Future _connectToEmulator() async {
  final host = Platform.isAndroid ? '10.0.2.2' : 'localhost';

  const firestorePort = 8080;
  const authPort = 9099;

  // Just to make sure we're running locally
  if (kDebugMode) {
    print("Using the firebase emulator");
  }

  FirebaseFirestore.instance.useFirestoreEmulator(host, firestorePort);
  await FirebaseAuth.instance.useAuthEmulator(host, authPort);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (!_isProduction) {
    await _connectToEmulator();
  }

  runApp(const MyApp());
}
