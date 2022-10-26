// ignore_for_file: prefer_const_constructors
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:test/test.dart';

const _mockValidTagName = 'mock tag name';
const _mockInvalidTagName = ' _?@';

void main() {
  group(
    'TagName',
    () {
      late TagName tagName;

      setUpAll(() {
        tagName = TagName.pure();
      });

      group('pure', () {
        test('has status of pure', () {
          expect(tagName.status, equals(FormzInputStatus.pure));
        });

        test('has value is empty string', () {
          expect(tagName.value, equals(''));
        });

        test('error is set to TagNameValidationError.invalid', () {
          expect(
            tagName.error,
            equals(TagNameValidationError.invalid),
          );
        });
      });

      group('invalid', () {
        setUp(() {
          tagName = TagName.dirty(value: _mockInvalidTagName);
        });
        test('has status of invalid', () {
          expect(tagName.status, equals(FormzInputStatus.invalid));
        });

        test('error is set to TagNameValidationError.invalid', () {
          expect(
            tagName.error,
            equals(TagNameValidationError.invalid),
          );
        });
      });

      group('valid', () {
        setUp(() {
          tagName = TagName.dirty(value: _mockValidTagName);
        });

        test('has status of valid', () {
          expect(tagName.status, equals(FormzInputStatus.valid));
        });

        test('error is null', () {
          expect(
            tagName.error,
            equals(null),
          );
        });
      });
    },
  );
}
