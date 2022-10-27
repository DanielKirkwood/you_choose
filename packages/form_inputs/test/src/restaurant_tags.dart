// ignore_for_file: prefer_const_constructors
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

class MockTag extends Mock implements Tag {}

final _tag = MockTag();
final _mockTagList = <Tag>[_tag];

void main() {
  group(
    'RestaurantTags',
    () {
      late RestaurantTags restaurantTags;

      setUpAll(() {
        restaurantTags = RestaurantTags.pure();
      });

      group('pure', () {
        test('has status of pure', () {
          expect(restaurantTags.status, equals(FormzInputStatus.pure));
        });

        test('has default value of empty tag list ', () {
          expect(restaurantTags.value, equals(<Tag>[]));
          expect(restaurantTags.value.isEmpty, equals(true));
        });

        test('error is set to null', () {
          expect(
            restaurantTags.error,
            equals(null),
          );
        });
      });

      group('valid', () {
        setUp(() {
          restaurantTags = RestaurantTags.dirty(
            value: _mockTagList,
          );
        });

        test('has status of valid', () {
          expect(restaurantTags.status, equals(FormzInputStatus.valid));
        });

        test('error is null', () {
          expect(
            restaurantTags.error,
            equals(null),
          );
        });
      });
    },
  );
}
