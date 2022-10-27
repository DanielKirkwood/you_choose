// ignore_for_file: prefer_const_constructors
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:test/test.dart';

const _mockValidUsername = 'username123';
const _mockInvalidUsername = '_.';

void main() {
  group(
    'Username',
    () {
      late Username username;

      setUpAll(() {
        username = Username.pure();
      });

      group('pure', () {
        test('has status of pure', () {
          expect(username.status, equals(FormzInputStatus.pure));
        });

        test('has value is empty string', () {
          expect(username.value, equals(''));
        });

        test('error is set to UsernameValidationError.invalid', () {
          expect(
            username.error,
            equals(UsernameValidationError.invalid),
          );
        });
      });

      group('invalid', () {
        setUp(() {
          username = Username.dirty(value: _mockInvalidUsername);
        });
        test('has status of invalid', () {
          expect(username.status, equals(FormzInputStatus.invalid));
        });

        test('error is set to UsernameValidationError.invalid', () {
          expect(
            username.error,
            equals(UsernameValidationError.invalid),
          );
        });
      });

      group('valid', () {
        setUp(() {
          username = Username.dirty(value: _mockValidUsername);
        });

        test('has status of valid', () {
          expect(username.status, equals(FormzInputStatus.valid));
        });

        test('error is null', () {
          expect(
            username.error,
            equals(null),
          );
        });
      });
    },
  );
}
