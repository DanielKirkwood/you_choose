// ignore_for_file: prefer_const_constructors
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:test/test.dart';

const _mockValidRestaurantDescription = 'mock valid description';
const _mockInvalidRestaurantDescription = '';

void main() {
  group(
    'RestaurantDescription',
    () {
      late RestaurantDescription restaurantDescription;

      setUpAll(() {
        restaurantDescription = RestaurantDescription.pure();
      });

      group('pure', () {
        test('has status of pure', () {
          expect(restaurantDescription.status, equals(FormzInputStatus.pure));
        });

        test('has default value of empty string ', () {
          expect(restaurantDescription.value, equals(''));
        });

        test('error is set to RestaurantDescriptionValidationError.invalid',
            () {
          expect(
            restaurantDescription.error,
            equals(RestaurantDescriptionValidationError.invalid),
          );
        });
      });

      group('invalid', () {
        setUp(() {
          restaurantDescription = RestaurantDescription.dirty(
            value: _mockInvalidRestaurantDescription,
          );
        });
        test('has status of invalid', () {
          expect(
              restaurantDescription.status, equals(FormzInputStatus.invalid));
        });

        test('error is set to RestaurantDescriptionValidationError.invalid',
            () {
          expect(
            restaurantDescription.error,
            equals(RestaurantDescriptionValidationError.invalid),
          );
        });
      });

      group('valid', () {
        setUp(() {
          restaurantDescription = RestaurantDescription.dirty(
            value: _mockValidRestaurantDescription,
          );
        });

        test('has status of valid', () {
          expect(restaurantDescription.status, equals(FormzInputStatus.valid));
        });

        test('error is null', () {
          expect(
            restaurantDescription.error,
            equals(null),
          );
        });
      });
    },
  );
}
