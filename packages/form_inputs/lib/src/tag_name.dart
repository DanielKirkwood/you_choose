import 'package:formz/formz.dart';

/// Validation errors for the [TagName] [FormzInput].
enum TagNameValidationError {
  /// Generic invalid error.
  invalid
}

/// {@template tagName}
/// Form input for an tag name input.
/// {@endtemplate}
class TagName extends FormzInput<String, TagNameValidationError> {
  /// {@macro tagName}
  const TagName.pure() : super.pure('');

  /// {@macro tagName}
  const TagName.dirty({required String value}) : super.dirty(value);

  static final RegExp _tagNameRegExp = RegExp(
    r'^[^-\s][a-zA-Z0-9_\s-]{1,30}$',
  );

  @override
  TagNameValidationError? validator(String value) {
    return _tagNameRegExp.hasMatch(value)
        ? null
        : TagNameValidationError.invalid;
  }
}
