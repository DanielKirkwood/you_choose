import 'package:formz/formz.dart';
import 'package:you_choose/src/data/data.dart';

enum RestaurantGroupsValidationError {
  /// Generic invalid error.
  invalid
}

class RestaurantGroups
    extends FormzInput<List<Group>, RestaurantGroupsValidationError> {
  const RestaurantGroups.pure() : super.pure(const <Group>[]);

  const RestaurantGroups.dirty({required List<Group> value})
      : super.dirty(value);

  @override
  RestaurantGroupsValidationError? validator(List<Group> value) {
    return value.isNotEmpty ? null : RestaurantGroupsValidationError.invalid;
  }
}
