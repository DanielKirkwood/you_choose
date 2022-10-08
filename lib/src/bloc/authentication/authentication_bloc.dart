import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:you_choose/src/models/models.dart';
import 'package:you_choose/src/repositories/repositories.dart';
import 'package:you_choose/src/util/logger/logger.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final FirebaseAuthRepository _authenticationRepository;
  final FirestoreRepository _databaseRepository;
  var logger = getLogger('AuthenticationBloc');

  AuthenticationBloc(this._authenticationRepository, this._databaseRepository)
      : super(AuthenticationInitial()) {
    on<AuthenticationStarted>(_onAuthenticationStarted);
    on<AuthenticationPasswordChanged>(_onAuthenticationPasswordChanged);
    on<AuthenticationProfileImageChanged>(_onAuthenticationProfileImageChanged);
    on<AuthenticationSignedOut>(_onAuthenticationSignedOut);
  }

  _onAuthenticationStarted(AuthenticationStarted event, Emitter emit) async {
    UserModel user = await _authenticationRepository.getCurrentUser().first;

    if (user != const UserModel.empty()) {
      UserModel userData =
          await _authenticationRepository.getUserData(email: user.email);

      emit(AuthenticationSuccess(user: userData));
    } else {
      emit(AuthenticationFailure());
    }
  }

  _onAuthenticationPasswordChanged(
      AuthenticationPasswordChanged event, Emitter emit) async {
    await _authenticationRepository.changeUserPassword(event.newPassword);
    emit(AuthenticationFailure());
  }

  _onAuthenticationSignedOut(
      AuthenticationSignedOut event, Emitter emit) async {
    await _authenticationRepository.signOut();
    emit(AuthenticationFailure());
  }

  _onAuthenticationProfileImageChanged(
      AuthenticationProfileImageChanged event, Emitter emit) async {
    await _databaseRepository.updateProfileImage(event.newImage, event.uid);

    UserModel user = await _authenticationRepository.getCurrentUser().first;

    if (user != const UserModel.empty()) {
      UserModel userData =
          await _authenticationRepository.getUserData(email: user.email);

      emit(AuthenticationSuccess(user: userData));
    } else {
      emit(AuthenticationFailure());
    }
  }
}
