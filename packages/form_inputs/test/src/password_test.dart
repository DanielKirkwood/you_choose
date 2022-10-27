// ignore_for_file: prefer_const_constructors
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:test/test.dart';

const _mockValidPassword = 'password123';
const _mockInvalidPassword = '_123';

void main() {
  group(
    'Password',
    () {
      late Password password;

      setUpAll(() {
        password = Password.pure();
      });

      group('pure', () {
        test('has status of pure', () {
          expect(password.status, equals(FormzInputStatus.pure));
        });

        test('has value is empty string', () {
          expect(password.value, equals(''));
        });

        test('error is set to PasswordValidationError.invalid', () {
          expect(
            password.error,
            equals(PasswordValidationError.invalid),
          );
        });
      });

      group('invalid', () {
        setUp(() {
          password = Password.dirty(value: _mockInvalidPassword);
        });
        test('has status of invalid', () {
          expect(password.status, equals(FormzInputStatus.invalid));
        });

        test('error is set to PasswordValidationError.invalid', () {
          expect(
            password.error,
            equals(PasswordValidationError.invalid),
          );
        });
      });

      group('valid', () {
        setUp(() {
          password = Password.dirty(value: _mockValidPassword);
        });

        test('has status of valid', () {
          expect(password.status, equals(FormzInputStatus.valid));
        });

        test('error is null', () {
          expect(
            password.error,
            equals(null),
          );
        });
      });
    },
  );
}
