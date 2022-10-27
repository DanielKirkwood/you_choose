// ignore_for_file: prefer_const_constructors
import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Group', () {
    const name = 'mock-name';
    const members = <String>[];

    test('uses value equality', () {
      expect(
        Group(name: name, members: members),
        equals(
          Group(name: name, members: members),
        ),
      );
    });

    test(
      'copyWith returns correct instance of Group',
      () {
        final group = Group(name: name, members: members);
        const updatedName = 'new-mock-name';

        expect(
          group,
          equals(
            Group(name: name, members: members),
          ),
        );

        expect(
          group.copyWith(name: updatedName),
          equals(
            Group(name: updatedName, members: members),
          ),
        );
      },
    );

    test('isEmpty returns true for empty group', () {
      expect(Group.empty.isEmpty, isTrue);
    });

    test('isEmpty returns false for non-empty group', () {
      final group = Group(name: name, members: members);
      expect(group.isEmpty, isFalse);
    });

    test('isNotEmpty returns false for empty group', () {
      expect(Group.empty.isNotEmpty, isFalse);
    });

    test('isNotEmpty returns true for non-empty group', () {
      final group = Group(name: name, members: members);
      expect(group.isNotEmpty, isTrue);
    });
  });
}
