// ignore_for_file: strict_raw_type

import 'package:bloc/bloc.dart';
import 'package:utilities/utilities.dart';

class AppBlocObserver extends BlocObserver {
  final logger = Utilities.getLogger('BlocObserver');

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    logger.i('onEvent $event');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    logger.e('onError $error');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    logger.i('onChange $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    logger.i('onTranisition $transition');
  }
}
