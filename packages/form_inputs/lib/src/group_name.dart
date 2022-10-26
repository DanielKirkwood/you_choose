import 'package:formz/formz.dart';

/// Validation errors for the [GroupName] [FormzInput].
enum GroupNameValidationError {
  /// Generic invalid error.
  invalid
}

/// {@template groupName}
/// Form input for an group name input.
/// {@endtemplate}
class GroupName extends FormzInput<String, GroupNameValidationError> {
  /// {@macro groupName}
  const GroupName.pure() : super.pure('');

  /// {@macro groupName}
  const GroupName.dirty({String value = ''}) : super.dirty(value);

  static final RegExp _groupNameRegExp = RegExp(
    r'^[^-\s][a-zA-Z0-9_\s-]{4,30}$',
  );

  @override
  GroupNameValidationError? validator(String? value) {
    return _groupNameRegExp.hasMatch(value ?? '')
        ? null
        : GroupNameValidationError.invalid;
  }
}
