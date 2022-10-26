// ignore_for_file: prefer_const_constructors
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:test/test.dart';

const _mockValidRestaurantName = 'mock valid restaurant';
const _mockInvalidRestaurantName = '_? n';

void main() {
  group(
    'RestaurantName',
    () {
      late RestaurantName restaurantName;

      setUpAll(() {
        restaurantName = RestaurantName.pure();
      });

      group('pure', () {
        test('has status of pure', () {
          expect(restaurantName.status, equals(FormzInputStatus.pure));
        });

        test('has default value of empty string ', () {
          expect(restaurantName.value, equals(''));
        });

        test('error is set to RestaurantNameValidationError.invalid', () {
          expect(
            restaurantName.error,
            equals(RestaurantNameValidationError.invalid),
          );
        });
      });

      group('invalid', () {
        setUp(() {
          restaurantName = RestaurantName.dirty(
            value: _mockInvalidRestaurantName,
          );
        });
        test('has status of invalid', () {
          expect(restaurantName.status, equals(FormzInputStatus.invalid));
        });

        test('error is set to RestaurantNameValidationError.invalid', () {
          expect(
            restaurantName.error,
            equals(RestaurantNameValidationError.invalid),
          );
        });
      });

      group('valid', () {
        setUp(() {
          restaurantName = RestaurantName.dirty(
            value: _mockValidRestaurantName,
          );
        });

        test('has status of valid', () {
          expect(restaurantName.status, equals(FormzInputStatus.valid));
        });

        test('error is null', () {
          expect(
            restaurantName.error,
            equals(null),
          );
        });
      });
    },
  );
}
