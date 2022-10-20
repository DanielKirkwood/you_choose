import 'package:formz/formz.dart';

enum UsernameValidationError { invalid }

class Username extends FormzInput<String, UsernameValidationError> {
  const Username.pure() : super.pure('');

  const Username.dirty({required String value}) : super.dirty(value);

  static final RegExp _usernameRegExp = RegExp(
    r'^(?=.{4,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$',
  );

  @override
  UsernameValidationError? validator(String value) {
    return _usernameRegExp.hasMatch(value)
        ? null
        : UsernameValidationError.invalid;
  }
}
