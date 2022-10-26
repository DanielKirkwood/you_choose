import 'package:formz/formz.dart';

/// Validation errors for the [RestaurantPrice] [FormzInput].
enum RestaurantPriceValidationError {
  /// Generic invalid error.
  invalid
}

/// {@template restaurantPrice}
/// Form input for an restaurant price input.
/// {@endtemplate}
class RestaurantPrice extends FormzInput<int, RestaurantPriceValidationError> {
  /// {@macro restaurantPrice}
  const RestaurantPrice.pure() : super.pure(1);

  /// {@macro restaurantPrice}
  const RestaurantPrice.dirty({required int value}) : super.dirty(value);

  @override
  RestaurantPriceValidationError? validator(int value) {
    final allowedValues = <int>[1, 2, 3, 4];
    return allowedValues.contains(value)
        ? null
        : RestaurantPriceValidationError.invalid;
  }
}
