import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:you_choose/src/models/models.dart';
import 'package:you_choose/src/repositories/repositories.dart';
import 'package:you_choose/src/util/logger/logger.dart';

part 'form_event.dart';
part 'form_state.dart';

class FormBloc extends Bloc<FormEvent, FormsValidate> {
  var logger = getLogger('FormBloc');
  final FirebaseAuthRepository _authenticationRepository;
  final FirestoreRepository _databaseRepository;
  FormBloc(this._authenticationRepository, this._databaseRepository)
      : super(const FormsValidate(
            email: "example@gmail.com",
            password: "",
            username: "example123",
            groupName: "example group",
            groupMembers: [],
            isEmailValid: true,
            isPasswordValid: true,
            isGroupNameValid: true,
            isGroupMembersValid: true,
            isFormValid: false,
            isLoading: false,
            isUsernameValid: true,
            isFormValidateFailed: false)) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<UsernameChanged>(_onUsernameChanged);
    on<GroupNameChanged>(_onGroupNameChanged);
    on<GroupMembersChanged>(_onGroupMembersChanged);
    on<FormSubmitted>(_onFormSubmitted);
    on<FormSucceeded>(_onFormSucceeded);
  }
  final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  final RegExp _usernameRegExp = RegExp(
    r'^(?=.{8,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$',
  );

  final RegExp _groupNameRegExp = RegExp(r'^[A-Za-z0-9-]{1,25}$');

  bool _isEmailValid(String email) {
    return _emailRegExp.hasMatch(email);
  }

  bool _isPasswordValid(String password) {
    return _passwordRegExp.hasMatch(password);
  }

  bool _isUsernameValid(String username) {
    return _usernameRegExp.hasMatch(username);
  }

  bool _isGroupNameValid(String groupName) {
    return _groupNameRegExp.hasMatch(groupName);
  }

  bool _isGroupMembersValid(List<String> groupMembers) {
    return groupMembers.isNotEmpty;
  }

  _onEmailChanged(EmailChanged event, Emitter<FormsValidate> emit) {
    emit(state.copyWith(
      isFormSuccessful: false,
      isFormValid: false,
      isFormValidateFailed: false,
      errorMessage: "",
      email: event.email,
      isEmailValid: _isEmailValid(event.email),
    ));
  }

  _onPasswordChanged(PasswordChanged event, Emitter<FormsValidate> emit) {
    emit(state.copyWith(
      isFormSuccessful: false,
      isFormValidateFailed: false,
      errorMessage: "",
      password: event.password,
      isPasswordValid: _isPasswordValid(event.password),
    ));
  }

  _onUsernameChanged(UsernameChanged event, Emitter<FormsValidate> emit) {
    emit(state.copyWith(
      isFormSuccessful: false,
      isFormValidateFailed: false,
      errorMessage: "",
      username: event.username,
      isUsernameValid: _isUsernameValid(event.username),
    ));
  }

  _onGroupNameChanged(GroupNameChanged event, Emitter<FormsValidate> emit) {
    emit(state.copyWith(
      isFormSuccessful: false,
      isFormValidateFailed: false,
      errorMessage: "",
      groupName: event.groupName,
      isGroupNameValid: _isGroupNameValid(event.groupName),
    ));
  }

  _onGroupMembersChanged(
      GroupMembersChanged event, Emitter<FormsValidate> emit) {
    emit(state.copyWith(
      isFormSuccessful: false,
      isFormValidateFailed: false,
      errorMessage: "",
      groupMembers: event.groupMembers,
      isGroupMembersValid: _isGroupMembersValid(event.groupMembers),
    ));
  }

  _onFormSubmitted(FormSubmitted event, Emitter<FormsValidate> emit) async {
    if (event.value == Status.signUp) {
      UserModel user = UserModel(
          email: state.email,
          password: state.password,
          username: state.username);

      await _updateUIAndSignUp(event, emit, user);
    } else if (event.value == Status.signIn) {
      UserModel user = UserModel(
          email: state.email,
          password: state.password,
          username: state.username);

      await _authenticateUser(event, emit, user);
    } else if (event.value == Status.createGroup) {
      Group group = Group(name: state.groupName, members: state.groupMembers);

      await _addNewGroup(event, emit, group);
    }
  }

  _addNewGroup(
      FormSubmitted event, Emitter<FormsValidate> emit, Group group) async {
    emit(state.copyWith(
        errorMessage: "",
        isFormValid: _isGroupNameValid(state.groupName) &&
            _isGroupMembersValid(state.groupMembers),
        isLoading: true));

    if (state.isFormValid) {
      try {
        await _databaseRepository.addGroup(group);

        emit(state.copyWith(isLoading: false, errorMessage: ""));
      } on FirebaseException catch (error) {
        emit(state.copyWith(
            isLoading: false, errorMessage: error.message, isFormValid: false));
      }
    }
  }

  _updateUIAndSignUp(
      FormSubmitted event, Emitter<FormsValidate> emit, UserModel user) async {
    emit(state.copyWith(
        errorMessage: "",
        isFormValid: _isPasswordValid(state.password) &&
            _isEmailValid(state.email) &&
            _isUsernameValid(state.username),
        isLoading: true));
    if (state.isFormValid) {
      try {
        UserCredential? authUser = await _authenticationRepository.signUp(user);

        UserModel updatedUser = user.copyWith(
            uid: authUser!.user!.uid, isVerified: authUser.user!.emailVerified);

        await _databaseRepository.addUserData(updatedUser);
        if (updatedUser.isVerified!) {
          emit(state.copyWith(isLoading: false, errorMessage: ""));
        } else {
          emit(state.copyWith(
              isFormValid: false,
              errorMessage:
                  "Please Verify your email, by clicking the link sent to you by mail.",
              isLoading: false));
        }
      } on FirebaseAuthException catch (e) {
        emit(state.copyWith(
            isLoading: false, errorMessage: e.message, isFormValid: false));
      } on FirebaseException catch (e) {
        emit(state.copyWith(
            isLoading: false, errorMessage: e.message, isFormValid: false));
      }
    } else {
      emit(state.copyWith(
          isLoading: false, isFormValid: false, isFormValidateFailed: true));
    }
  }

  _authenticateUser(
      FormSubmitted event, Emitter<FormsValidate> emit, UserModel user) async {
    emit(state.copyWith(
        errorMessage: "",
        isFormValid:
            _isPasswordValid(state.password) && _isEmailValid(state.email),
        isLoading: true));
    if (state.isFormValid) {
      try {
        UserCredential? authUser = await _authenticationRepository.signIn(user);

        UserModel updatedUser =
            user.copyWith(isVerified: authUser!.user!.emailVerified);
        if (updatedUser.isVerified!) {
          emit(state.copyWith(isLoading: false, errorMessage: ""));
        } else {
          emit(state.copyWith(
              isFormValid: false,
              errorMessage:
                  "Please Verify your email, by clicking the link sent to you by mail.",
              isLoading: false));
        }
      } on FirebaseAuthException catch (e) {
        emit(state.copyWith(
            isLoading: false, errorMessage: e.message, isFormValid: false));
      }
    } else {
      emit(state.copyWith(
          isLoading: false, isFormValid: false, isFormValidateFailed: true));
    }
  }

  _onFormSucceeded(FormSucceeded event, Emitter<FormsValidate> emit) {
    emit(state.copyWith(isFormSuccessful: true));
  }
}
