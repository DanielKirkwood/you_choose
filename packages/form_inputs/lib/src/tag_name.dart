import 'package:formz/formz.dart';

enum TagNameValidationError {
  /// Generic invalid error.
  invalid
}

class TagName extends FormzInput<String, TagNameValidationError> {
  const TagName.pure() : super.pure('');

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
