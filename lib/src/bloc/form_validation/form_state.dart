part of 'form_bloc.dart';

abstract class FormState extends Equatable {
  const FormState();
}

class FormInitial extends FormState {
  @override
  List<Object?> get props => [];
}

class FormsValidate extends FormState {
  const FormsValidate(
      {required this.email,
      required this.password,
      required this.groupName,
      required this.groupMembers,
      required this.isEmailValid,
      required this.isPasswordValid,
      required this.isGroupNameValid,
      required this.isGroupMembersValid,
      required this.isFormValid,
      required this.isLoading,
      this.errorMessage = "",
      required this.isUsernameValid,
      required this.isFormValidateFailed,
      required this.username,
      this.isFormSuccessful = false});

  final String email;
  final String username;
  final String password;
  final String groupName;
  final List<String> groupMembers;
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isGroupNameValid;
  final bool isFormValid;
  final bool isUsernameValid;
  final bool isGroupMembersValid;
  final bool isFormValidateFailed;
  final bool isLoading;
  final String errorMessage;
  final bool isFormSuccessful;

  FormsValidate copyWith(
      {String? email,
      String? password,
      String? username,
      String? groupName,
      List<String>? groupMembers,
      bool? isEmailValid,
      bool? isPasswordValid,
      bool? isGroupNameValid,
      bool? isGroupMembersValid,
      bool? isFormValid,
      bool? isLoading,
      int? age,
      String? errorMessage,
      bool? isUsernameValid,
      bool? isAgeValid,
      bool? isFormValidateFailed,
      bool? isFormSuccessful}) {
    return FormsValidate(
        email: email ?? this.email,
        password: password ?? this.password,
        groupName: groupName ?? this.groupName,
        groupMembers: groupMembers ?? this.groupMembers,
        isEmailValid: isEmailValid ?? this.isEmailValid,
        isPasswordValid: isPasswordValid ?? this.isPasswordValid,
        isGroupNameValid: isGroupNameValid ?? this.isGroupNameValid,
        isGroupMembersValid: isGroupMembersValid ?? this.isGroupMembersValid,
        isFormValid: isFormValid ?? this.isFormValid,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage ?? this.errorMessage,
        isUsernameValid: isUsernameValid ?? this.isUsernameValid,
        username: username ?? this.username,
        isFormValidateFailed: isFormValidateFailed ?? this.isFormValidateFailed,
        isFormSuccessful: isFormSuccessful ?? this.isFormSuccessful);
  }

  @override
  List<Object?> get props => [
        email,
        password,
        groupName,
        groupMembers,
        isEmailValid,
        isPasswordValid,
        isGroupNameValid,
        isGroupMembersValid,
        isFormValid,
        isLoading,
        errorMessage,
        isUsernameValid,
        username,
        isFormValidateFailed,
        isFormSuccessful
      ];
}
