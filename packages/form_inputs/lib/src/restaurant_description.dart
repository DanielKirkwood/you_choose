import 'package:formz/formz.dart';

enum RestaurantDescriptionValidationError {
  /// Generic invalid error.
  invalid
}

class RestaurantDescription
    extends FormzInput<String, RestaurantDescriptionValidationError> {
  const RestaurantDescription.pure() : super.pure('');

  const RestaurantDescription.dirty({required String value})
      : super.dirty(value);

  @override
  RestaurantDescriptionValidationError? validator(String value) {
    return value.isNotEmpty
        ? null
        : RestaurantDescriptionValidationError.invalid;
  }
}
