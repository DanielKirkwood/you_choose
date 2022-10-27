// ignore_for_file: prefer_const_constructors
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

class MockGroup extends Mock implements Group {}

const _mockValidMembers = 'mock, members';

void main() {
  group(
    'GroupMembers',
    () {
      late GroupMembers groupMembers;

      setUpAll(() {
        groupMembers = GroupMembers.pure();
      });

      group('pure', () {
        test('has status of pure', () {
          expect(groupMembers.status, equals(FormzInputStatus.pure));
        });

        test('has default value of empty string ', () {
          expect(groupMembers.value, equals(''));
          expect(groupMembers.value.isEmpty, equals(true));
        });

        test('error is set to GroupMembersValidationError.invalid', () {
          expect(
            groupMembers.error,
            equals(GroupMembersValidationError.invalid),
          );
        });
      });

      group('invalid', () {
        setUp(() {
          groupMembers = GroupMembers.dirty();
        });
        test('has status of invalid', () {
          expect(groupMembers.status, equals(FormzInputStatus.invalid));
        });

        test('error is set to RestaurantNameValidationError.invalid', () {
          expect(
            groupMembers.error,
            equals(GroupMembersValidationError.invalid),
          );
        });
      });

      group('valid', () {
        setUp(() {
          groupMembers = GroupMembers.dirty(
            value: _mockValidMembers,
          );
        });

        test('has status of valid', () {
          expect(groupMembers.status, equals(FormzInputStatus.valid));
        });

        test('error is null', () {
          expect(
            groupMembers.error,
            equals(null),
          );
        });
      });
    },
  );
}
