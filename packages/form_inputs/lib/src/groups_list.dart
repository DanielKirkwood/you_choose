import 'package:formz/formz.dart';
import 'package:models/models.dart';

/// Validation errors for the [GroupsList] [FormzInput].
enum GroupsListValidationError {
  /// Generic invalid error.
  invalid
}

/// {@template groupsList}
/// Form input for an groups list input.
/// {@endtemplate}
class GroupsList extends FormzInput<List<Group>, GroupsListValidationError> {
  /// {@macro groupsList}
  const GroupsList.pure() : super.pure(const <Group>[]);

  /// {@macro groupsList}
  const GroupsList.dirty({required List<Group> value}) : super.dirty(value);

  @override
  GroupsListValidationError? validator(List<Group> value) {
    return value.isNotEmpty ? null : GroupsListValidationError.invalid;
  }
}
