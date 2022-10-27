// ignore_for_file: prefer_const_constructors
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:test/test.dart';

const _mockEmail = 'mock@test.com';
const _mockInvalidEmail = 'invalid-email';

void main() {
  group(
    'Email',
    () {
      late Email email;

      setUpAll(() {
        email = Email.pure();
      });

      group('pure', () {
        test('has status of pure', () {
          expect(email.status, equals(FormzInputStatus.pure));
        });

        test('has value is empty string', () {
          expect(email.value, equals(''));
        });

        test('error is set to EmailValidationError.invalid', () {
          expect(
            email.error,
            equals(EmailValidationError.invalid),
          );
        });
      });

      group('invalid', () {
        setUp(() {
          email = Email.dirty(value: _mockInvalidEmail);
        });
        test('has status of invalid', () {
          expect(email.status, equals(FormzInputStatus.invalid));
        });

        test('error is set to EmailValidationError.invalid', () {
          expect(
            email.error,
            equals(EmailValidationError.invalid),
          );
        });
      });

      group('valid', () {
        setUp(() {
          email = Email.dirty(value: _mockEmail);
        });

        test('has status of valid', () {
          expect(email.status, equals(FormzInputStatus.valid));
        });

        test('error is null', () {
          expect(
            email.error,
            equals(null),
          );
        });
      });
    },
  );
}
