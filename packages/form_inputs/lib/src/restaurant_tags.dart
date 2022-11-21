import 'package:formz/formz.dart';

/// Validation errors for the [RestaurantTags] [FormzInput].
enum RestaurantTagsValidationError {
  /// Generic invalid error.
  invalid
}

/// {@template restaurantTags}
/// Form input for an restaurant tags input.
/// {@endtemplate}
class RestaurantTags
    extends FormzInput<List<String>, RestaurantTagsValidationError> {
  /// {@macro restaurantTags}
  const RestaurantTags.pure() : super.pure(const <String>[]);

  /// {@macro restaurantTags}
  const RestaurantTags.dirty({required List<String> value})
      : super.dirty(value);

  @override
  RestaurantTagsValidationError? validator(List<String> value) {
    return null;
  }
}
