import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:utilities/utilities.dart';
import 'package:you_choose/firebase_options.dart';
import 'package:you_choose/src/app/app.dart';
import 'package:you_choose/src/app/bloc_observer.dart';

Future<void> main() async {
  final logger = Utilities.getLogger('main');
  const isProduction = bool.fromEnvironment('dart.vm.product');

  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (!isProduction) {
    logger.d('Connecting to firebase emulators');

    await Utilities.setupEmulators();
  }

  final authenticationRepository = AuthenticationRepository();
  await authenticationRepository.user.first;

  runApp(App(authenticationRepository: authenticationRepository));
}
