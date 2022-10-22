import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:you_choose/src/data/data.dart';
import 'package:you_choose/src/restaurant/cubit/restaurant_cubit.dart';
import 'package:you_choose/src/util/form_inputs/form_inputs.dart';

void main() {
  group(
    "RestaurantState",
    () {
      late RestaurantState restaurantState;

      setUp(() {
        restaurantState = const RestaurantState();
      });

      test(
        "initial state set",
        () {
          expect(restaurantState.restaurants, const <Restaurant>[]);
          expect(restaurantState.status, RestaurantStatus.initial);
          expect(restaurantState.name, const RestaurantName.pure());
          expect(restaurantState.price, const RestaurantPrice.pure());
          expect(
              restaurantState.description, const RestaurantDescription.pure());
          expect(restaurantState.tags, const RestaurantTags.pure());
          expect(restaurantState.groups, const GroupsList.pure());
          expect(restaurantState.formStatus, FormzStatus.pure);
          expect(restaurantState.errorMessage, null);
        },
      );

      test(
        "copyWith function edits correct fields",
        () {
          RestaurantName initialRestaurantName = const RestaurantName.pure();
          RestaurantName newRestaurantName =
              const RestaurantName.dirty(value: 'test');

          // check name is initial
          expect(restaurantState.name, initialRestaurantName);

          // use copyWith to change name state
          restaurantState = restaurantState.copyWith(name: newRestaurantName);

          // expect name state to have changed
          expect(restaurantState.name, newRestaurantName);
        },
      );

      test(
        "equality check",
        () {
          RestaurantState initialState = const RestaurantState();

          expect(restaurantState, initialState);
        },
      );
    },
  );
}
