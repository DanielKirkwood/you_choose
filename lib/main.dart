import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:you_choose/src/app.dart';
import 'package:you_choose/src/bloc/bloc_observer.dart';
import 'package:you_choose/src/util/logger/logger.dart';

import 'firebase_options.dart';

Future<void> _setupEmulators() async {
  const firestorePort = 8080;
  const authPort = 9099;
  const storagePort = 9199;

  final emulatorHost =
      (!kIsWeb && defaultTargetPlatform == TargetPlatform.android)
          ? '10.0.2.2'
          : 'localhost';

  // [Firestore | localhost:8080]
  FirebaseFirestore.instance.settings = const Settings(
    host: 'localhost:$firestorePort',
    sslEnabled: false,
    persistenceEnabled: false,
  );

  // [Authentication | localhost:9099]
  await FirebaseAuth.instance.useAuthEmulator(emulatorHost, authPort);

  // [Storage | localhost:9199]
  await FirebaseStorage.instance.useStorageEmulator(emulatorHost, storagePort);
}

Future<void> main() async {
  var logger = getLogger('main');
  const bool isProduction = bool.fromEnvironment('dart.vm.product');

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (!isProduction) {
    logger.d('Connecting to firebase emulators');

    await _setupEmulators();
  }


  Bloc.observer = MyBlocObserver();

  final storage = await HydratedStorage.build(
      storageDirectory: await getTemporaryDirectory());

  HydratedBlocOverrides.runZoned(
    () => runApp(const MyApp()),
    storage: storage,
  );
}
