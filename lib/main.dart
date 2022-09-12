import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:you_choose/src/app.dart';
import 'package:you_choose/src/bloc/authentication/authentication_bloc.dart';
import 'package:you_choose/src/bloc/bloc_observer.dart';
import 'package:you_choose/src/bloc/database/database_bloc.dart';
import 'package:you_choose/src/bloc/form_validation/form_bloc.dart';
import 'package:you_choose/src/services/authentication/authentication_repository_impl.dart';
import 'package:you_choose/src/services/database/database_repository_impl.dart';
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

  const firestorePort = 8080;
  const authPort = 9099;

  if (!isProduction) {
    logger.d('Connecting to firebase emulators');

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
        return AuthenticationBloc(AuthenticationRepositoryImpl())
          ..add(AuthenticationStarted());
      }),
      BlocProvider(create: (context) {
        return FormBloc(
            AuthenticationRepositoryImpl(), DatabaseRepositoryImpl());
      }),
      BlocProvider(create: (context) {
        return DatabaseBloc(DatabaseRepositoryImpl());
      })
    ],
    child: const MyApp(),
  ));
}
