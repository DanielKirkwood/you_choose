import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
// import 'package:flutter_firebase_login/app/app.dart';
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
  Bloc.observer = AppBlocObserver();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (!isProduction) {
    logger.d('Connecting to firebase emulators');

    await _setupEmulators();
  }

  final authenticationRepository = AuthenticationRepository();
  await authenticationRepository.user.first;

  runApp(MyApp(authenticationRepository: authenticationRepository));
}
