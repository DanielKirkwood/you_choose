// ignore_for_file: prefer_const_constructors
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:test/test.dart';

const _mockValidRestaurantPrice = 3;
const _mockInvalidRestaurantPrice = 5;

void main() {
  group(
    'RestaurantPrice',
    () {
      late RestaurantPrice restaurantPrice;

      setUpAll(() {
        restaurantPrice = RestaurantPrice.pure();
      });

      group('pure', () {
        test('has status of pure', () {
          expect(restaurantPrice.status, equals(FormzInputStatus.pure));
        });

        test('has default value of 1', () {
          expect(restaurantPrice.value, equals(1));
        });

        test('error is set to null', () {
          expect(
            restaurantPrice.error,
            equals(null),
          );
        });
      });

      group('invalid', () {
        setUp(() {
          restaurantPrice = RestaurantPrice.dirty(
            value: _mockInvalidRestaurantPrice,
          );
        });
        test('has status of invalid', () {
          expect(restaurantPrice.status, equals(FormzInputStatus.invalid));
        });

        test('error is set to RestaurantPriceValidationError.invalid', () {
          expect(
            restaurantPrice.error,
            equals(RestaurantPriceValidationError.invalid),
          );
        });
      });

      group('valid', () {
        setUp(() {
          restaurantPrice = RestaurantPrice.dirty(
            value: _mockValidRestaurantPrice,
          );
        });

        test('has status of valid', () {
          expect(restaurantPrice.status, equals(FormzInputStatus.valid));
        });

        test('error is null', () {
          expect(
            restaurantPrice.error,
            equals(null),
          );
        });
      });
    },
  );
}
