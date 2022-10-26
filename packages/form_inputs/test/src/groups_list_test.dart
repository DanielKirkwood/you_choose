// ignore_for_file: prefer_const_constructors
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

class MockGroup extends Mock implements Group {}

final _group = MockGroup();
final _mockGroupList = <Group>[_group];
final _mockInvalidGroupsList = <Group>[];

void main() {
  group(
    'GroupsList',
    () {
      late GroupsList groupsList;

      setUpAll(() {
        groupsList = GroupsList.pure();
      });

      group('pure', () {
        test('has status of pure', () {
          expect(groupsList.status, equals(FormzInputStatus.pure));
        });

        test('has default value of empty group list ', () {
          expect(groupsList.value, equals(<Group>[]));
          expect(groupsList.value.isEmpty, equals(true));
        });

        test('error is set to GroupsListValidationError.invalid', () {
          expect(
            groupsList.error,
            equals(GroupsListValidationError.invalid),
          );
        });
      });

      group('invalid', () {
        setUp(() {
          groupsList = GroupsList.dirty(
            value: _mockInvalidGroupsList,
          );
        });
        test('has status of invalid', () {
          expect(groupsList.status, equals(FormzInputStatus.invalid));
        });

        test('error is set to RestaurantNameValidationError.invalid', () {
          expect(
            groupsList.error,
            equals(GroupsListValidationError.invalid),
          );
        });
      });

      group('valid', () {
        setUp(() {
          groupsList = GroupsList.dirty(
            value: _mockGroupList,
          );
        });

        test('has status of valid', () {
          expect(groupsList.status, equals(FormzInputStatus.valid));
        });

        test('error is null', () {
          expect(
            groupsList.error,
            equals(null),
          );
        });
      });
    },
  );
}
