import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:utilities/src/log_printer.dart';

/// {@template utilities}
/// To hold utility classes for projects.
/// {@endtemplate}
class Utilities {
  /// {@macro utilities}
  const Utilities();

  /// setups firestore, firebase-auth and firebase-storage emulators.
  static Future<void> setupEmulators({
    int firestorePort = 8080,
    int authPort = 9099,
    int storagePort = 9199,
  }) async {
    final emulatorHost =
        (!kIsWeb && defaultTargetPlatform == TargetPlatform.android)
            ? '10.0.2.2'
            : 'localhost';

    // [Firestore | localhost:8080]
    FirebaseFirestore.instance.settings = Settings(
      host: 'localhost:$firestorePort',
      sslEnabled: false,
      persistenceEnabled: false,
    );

    // [Authentication | localhost:9099]
    await FirebaseAuth.instance.useAuthEmulator(emulatorHost, authPort);

    // [Storage | localhost:9199]
    await FirebaseStorage.instance
        .useStorageEmulator(emulatorHost, storagePort);
  }

  /// provides a basic [Logger]
  static Logger getLogger(String? className) {
    return Logger(printer: SimpleLogPrinter(className: className));
  }
}
