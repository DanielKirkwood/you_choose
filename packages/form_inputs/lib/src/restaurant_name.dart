import 'package:formz/formz.dart';

/// Validation errors for the [RestaurantName] [FormzInput].
enum RestaurantNameValidationError {
  /// Generic invalid error.
  invalid
}

/// {@template restaurantName}
/// Form input for an restaurant name input.
/// {@endtemplate}
class RestaurantName extends FormzInput<String, RestaurantNameValidationError> {
  /// {@macro restaurantName}
  const RestaurantName.pure() : super.pure('');

  /// {@macro restaurantName}
  const RestaurantName.dirty({required String value}) : super.dirty(value);

  static final RegExp _restaurantNameRegExp = RegExp(
    r'^[^-\s][a-zA-Z0-9_\s-]{1,30}$',
  );

  @override
  RestaurantNameValidationError? validator(String value) {
    return _restaurantNameRegExp.hasMatch(value)
        ? null
        : RestaurantNameValidationError.invalid;
  }
}
