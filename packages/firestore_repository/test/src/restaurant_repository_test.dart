import 'package:firestore_repository/firestore_repository.dart';
// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RestaurantRepository', () {
    test('can be instantiated', () {
      expect(RestaurantRepository(), isNotNull);
    });
  });
}
