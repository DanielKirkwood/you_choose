import 'package:formz/formz.dart';

/// Validation errors for the [GroupMembers] [FormzInput].
enum GroupMembersValidationError {
  /// Generic invalid error.
  invalid
}

/// {@template groupMembers}
/// Form input for an group members input.
/// {@endtemplate}
class GroupMembers extends FormzInput<String, GroupMembersValidationError> {
  /// {@macro groupMembers}
  const GroupMembers.pure() : super.pure('');

  /// {@macro groupMembers}
  const GroupMembers.dirty({String value = ''}) : super.dirty(value);

  @override
  GroupMembersValidationError? validator(String value) {
    return value.isNotEmpty == true
        ? null
        : GroupMembersValidationError.invalid;
  }
}
