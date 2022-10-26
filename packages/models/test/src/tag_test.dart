// ignore_for_file: prefer_const_constructors

import 'package:test/test.dart';

import '../../lib/models.dart';

void main() {
  group('Tag', () {
    const name = 'mock-name';

    test('uses value equality', () {
      expect(
        Tag(name: name),
        equals(
          Tag(name: name),
        ),
      );
    });

    test(
      'copyWith returns correct instance of Group',
      () {
        final tag = Tag(name: name);
        const updatedName = 'new-mock-name';

        expect(
          tag,
          equals(
            Tag(name: name),
          ),
        );

        expect(
          tag.copyWith(name: updatedName),
          equals(
            Tag(name: updatedName),
          ),
        );
      },
    );
  });
}
