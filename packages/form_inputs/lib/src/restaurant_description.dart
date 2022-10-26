import 'package:formz/formz.dart';

/// Validation errors for the [RestaurantDescription] [FormzInput].
enum RestaurantDescriptionValidationError {
  /// Generic invalid error.
  invalid
}

/// {@template restaurantDescription}
/// Form input for an restaurant description input.
/// {@endtemplate}
class RestaurantDescription
    extends FormzInput<String, RestaurantDescriptionValidationError> {
  /// {@macro restaurantDescription}
  const RestaurantDescription.pure() : super.pure('');

  /// {@macro restaurantDescription}
  const RestaurantDescription.dirty({required String value})
      : super.dirty(value);

  @override
  RestaurantDescriptionValidationError? validator(String value) {
    return value.isNotEmpty
        ? null
        : RestaurantDescriptionValidationError.invalid;
  }
}
