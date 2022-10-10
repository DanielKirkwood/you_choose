import 'package:formz/formz.dart';

enum RestaurantPriceValidationError { invalid }

class RestaurantPrice extends FormzInput<int, RestaurantPriceValidationError> {
  const RestaurantPrice.pure() : super.pure(1);

  const RestaurantPrice.dirty({required int value}) : super.dirty(value);

  @override
  RestaurantPriceValidationError? validator(int value) {
    List<int> allowedValues = [1, 2, 3, 4];
    return allowedValues.contains(value)
        ? null
        : RestaurantPriceValidationError.invalid;
  }
}
