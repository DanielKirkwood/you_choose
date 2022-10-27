import 'package:formz/formz.dart';
import 'package:models/models.dart';

/// Validation errors for the [RestaurantTags] [FormzInput].
enum RestaurantTagsValidationError {
  /// Generic invalid error.
  invalid
}

/// {@template restaurantTags}
/// Form input for an restaurant tags input.
/// {@endtemplate}
class RestaurantTags
    extends FormzInput<List<Tag>, RestaurantTagsValidationError> {
  /// {@macro restaurantTags}
  const RestaurantTags.pure() : super.pure(const <Tag>[]);

  /// {@macro restaurantTags}
  const RestaurantTags.dirty({required List<Tag> value}) : super.dirty(value);

  @override
  RestaurantTagsValidationError? validator(List<Tag> value) {
    return null;
  }
}
