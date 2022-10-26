// ignore_for_file: prefer_const_constructors
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:test/test.dart';

const _mockValidGroupName = 'mock valid group name';
const _mockInvalidGroupName = ' ?_ ';

void main() {
  group(
    'GroupName',
    () {
      late GroupName groupName;

      setUpAll(() {
        groupName = GroupName.pure();
      });

      group('pure', () {
        test('has status of pure', () {
          expect(groupName.status, equals(FormzInputStatus.pure));
        });

        test('has default value of empty string ', () {
          expect(groupName.value, equals(''));
        });

        test('error is set to GroupNameValidationError.invalid', () {
          expect(
            groupName.error,
            equals(GroupNameValidationError.invalid),
          );
        });
      });

      group('invalid', () {
        setUp(() {
          groupName = GroupName.dirty(
            value: _mockInvalidGroupName,
          );
        });
        test('has status of invalid', () {
          expect(groupName.status, equals(FormzInputStatus.invalid));
        });

        test('error is set to GroupNameValidationError.invalid', () {
          expect(
            groupName.error,
            equals(GroupNameValidationError.invalid),
          );
        });
      });

      group('valid', () {
        setUp(() {
          groupName = GroupName.dirty(
            value: _mockValidGroupName,
          );
        });

        test('has status of valid', () {
          expect(groupName.status, equals(FormzInputStatus.valid));
        });

        test('error is null', () {
          expect(
            groupName.error,
            equals(null),
          );
        });
      });
    },
  );
}
