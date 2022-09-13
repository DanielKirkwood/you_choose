import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:you_choose/src/models/models.dart';
import 'package:you_choose/src/repositories/repositories.dart';
import 'package:you_choose/src/util/logger/logger.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final FirebaseAuthRepository _authenticationRepository;
  var logger = getLogger('AuthenticationBloc');

  AuthenticationBloc(this._authenticationRepository)
      : super(AuthenticationInitial()) {
    on<AuthenticationEvent>((event, emit) async {
      if (event is AuthenticationStarted) {
        logger.d('event is AuthenticationStarted');
        UserModel user = await _authenticationRepository.getCurrentUser().first;

        if (user.uid != 'uid') {
          logger.d('user.uid is not null - ${user.uid}');

          String? username =
              await _authenticationRepository.getUsername(user);

          emit(AuthenticationSuccess(username: username));
        } else {
          logger.e('user.uid is null - emit AuthenticationFailure');

          emit(AuthenticationFailure());
        }
      } else if (event is AuthenticationSignedOut) {
        await _authenticationRepository.signOut();
        emit(AuthenticationFailure());
      }
    });
  }
}
