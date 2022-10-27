// ignore_for_file: prefer_const_constructors

import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Restaurant', () {
    const name = 'mock-name';
    const price = 1;
    const description = 'mock-description';
    const tags = <Tag>[];
    const docID = 'mock-docID';

    test('uses value equality', () {
      expect(
        Restaurant(
          name: name,
          price: price,
          description: description,
          tags: tags,
          docID: docID,
        ),
        equals(
          Restaurant(
            name: name,
            price: price,
            description: description,
            tags: tags,
            docID: docID,
          ),
        ),
      );
    });

    test(
      'copyWith returns correct instance of Restaurant',
      () {
        final restaurant =
            Restaurant(name: name, price: price, description: description);
        const updatedName = 'new-mock-name';

        expect(
          restaurant,
          equals(
            Restaurant(
              name: name,
              price: price,
              description: description,
            ),
          ),
        );

        expect(
          restaurant.copyWith(name: updatedName),
          equals(
            Restaurant(
              name: updatedName,
              price: price,
              description: description,
            ),
          ),
        );
      },
    );

    test('Restaurant cannot be created with price not in range 1-4, inclusive',
        () {
      expect(
        () => Restaurant(name: name, price: 5, description: description),
        throwsA(
          predicate(
            (e) =>
                e is AssertionError &&
                e.message == 'price must be between 1 and 4 inclusive.',
          ),
        ),
      );
    });
  });
}
