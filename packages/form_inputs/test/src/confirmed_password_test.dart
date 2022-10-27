// ignore_for_file: prefer_const_constructors
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:test/test.dart';

const _mockActualPassword = 'mock-password';
const _mockWrongPassword = 'mock-wrong-password';

void main() {
  group(
    'ConfirmedPassword',
    () {
      late ConfirmedPassword confirmPassword;

      setUpAll(() {
        confirmPassword = ConfirmedPassword.pure(
          actualPassword: _mockActualPassword,
        );
      });

      group('pure', () {
        test('has status of pure', () {
          expect(confirmPassword.status, equals(FormzInputStatus.pure));
        });

        test('has value is empty string', () {
          expect(confirmPassword.value, equals(''));
        });

        test('has actualPassword equal to _mockPassword', () {
          expect(confirmPassword.actualPassword, equals(_mockActualPassword));
        });

        test('error is set to ConfirmedPasswordValidationError.invalid', () {
          expect(
            confirmPassword.error,
            equals(ConfirmedPasswordValidationError.invalid),
          );
        });
      });

      group('invalid', () {
        setUp(() {
          confirmPassword = ConfirmedPassword.dirty(
            actualPassword: _mockActualPassword,
            value: _mockWrongPassword,
          );
        });
        test('has status of invalid', () {
          expect(confirmPassword.status, equals(FormzInputStatus.invalid));
        });

        test('value does not equal actualPassword', () {
          expect(confirmPassword.value != confirmPassword.actualPassword, true);
        });

        test('error is set to ConfirmedPasswordValidationError.invalid', () {
          expect(
            confirmPassword.error,
            equals(ConfirmedPasswordValidationError.invalid),
          );
        });
      });

      group('valid', () {
        setUp(() {
          confirmPassword = ConfirmedPassword.dirty(
            actualPassword: _mockActualPassword,
            value: _mockActualPassword,
          );
        });

        test('has status of valid', () {
          expect(confirmPassword.status, equals(FormzInputStatus.valid));
        });

        test('value equals actualPassword', () {
          expect(confirmPassword.value == confirmPassword.actualPassword, true);
        });

        test('error is null', () {
          expect(
            confirmPassword.error,
            equals(null),
          );
        });
      });
    },
  );
}
