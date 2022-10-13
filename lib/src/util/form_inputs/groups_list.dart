import 'package:formz/formz.dart';
import 'package:you_choose/src/data/data.dart';

enum GroupsListValidationError {
  /// Generic invalid error.
  invalid
}

class GroupsList extends FormzInput<List<Group>, GroupsListValidationError> {
  const GroupsList.pure() : super.pure(const <Group>[]);

  const GroupsList.dirty({required List<Group> value})
      : super.dirty(value);

  @override
  GroupsListValidationError? validator(List<Group> value) {
    return value.isNotEmpty ? null : GroupsListValidationError.invalid;
  }
}
