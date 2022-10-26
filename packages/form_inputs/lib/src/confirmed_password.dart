import 'package:formz/formz.dart';

/// Validation errors for the [ConfirmedPassword] [FormzInput].
enum ConfirmedPasswordValidationError {
  /// Generic invalid error.
  invalid
}

/// {@template confirmed_password}
/// Form input for a confirmed password input.
/// {@endtemplate}
class ConfirmedPassword
    extends FormzInput<String, ConfirmedPasswordValidationError> {
  /// {@macro confirmed_password}
  const ConfirmedPassword.pure({required this.actualPassword}) : super.pure('');

  /// {@macro confirmed_password}
  const ConfirmedPassword.dirty({
    required this.actualPassword,
    String value = '',
  })
      : super.dirty(value);

  /// The original password.
  final String actualPassword;

  @override
  ConfirmedPasswordValidationError? validator(String? value) {
    return actualPassword == value
        ? null
        : ConfirmedPasswordValidationError.invalid;
  }
}
