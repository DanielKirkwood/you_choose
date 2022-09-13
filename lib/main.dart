import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:you_choose/src/app.dart';
import 'package:you_choose/src/bloc/authentication/authentication_bloc.dart';
import 'package:you_choose/src/bloc/bloc_observer.dart';
import 'package:you_choose/src/bloc/form_validation/form_bloc.dart';
import 'package:you_choose/src/bloc/user/user_bloc.dart';
import 'package:you_choose/src/repositories/repositories.dart';
import 'package:you_choose/src/util/logger/logger.dart';

import 'firebase_options.dart';

Future<void> main() async {
  var logger = getLogger('main');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Bloc.observer = MyBlocObserver();

  const bool isProduction = bool.fromEnvironment('dart.vm.product');

  if (!isProduction) {
    logger.d('Connecting to firebase emulators');

    const firestorePort = 8080;
    const authPort = 9099;

    // [Firestore | localhost:8080]
    FirebaseFirestore.instance.settings = const Settings(
      host: 'localhost:$firestorePort',
      sslEnabled: false,
      persistenceEnabled: false,
    );

    // [Authentication | localhost:9099]
    await FirebaseAuth.instance.useAuthEmulator('localhost', authPort);
  }

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) {
        return AuthenticationBloc(FirebaseAuthRepository())
          ..add(AuthenticationStarted());
      }),
      BlocProvider(create: (context) {
        return FormBloc(
            FirebaseAuthRepository(), FirestoreRepository());
      }),
      BlocProvider(create: (context) {
        return UserBloc(FirestoreRepository());
      })
    ],
    child: const MyApp(),
  ));
}
