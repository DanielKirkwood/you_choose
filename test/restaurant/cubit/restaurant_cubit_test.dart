import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:you_choose/src/data/data.dart';
import 'package:you_choose/src/repositories/repositories.dart';
import 'package:you_choose/src/restaurant/cubit/restaurant_cubit.dart';
import 'package:you_choose/src/util/form_inputs/form_inputs.dart';
import 'package:you_choose/src/util/form_inputs/restaurant.price.dart';
import 'package:you_choose/src/util/form_inputs/restaurant_name.dart';

String groupID = 'test123';
Restaurant restaurant =
    Restaurant(name: 'test', price: 1, description: 'test description');

class MockFirestoreRepository extends Mock implements FirestoreRepository {}

void main() {
  // setUpAll(() {
  //   registerFallbackValue(restaurant);
  // });
  group(
    "RestaurantCubit",
    () {
      late FirestoreRepository firestoreRepository;

      setUp(() {
        firestoreRepository = MockFirestoreRepository();

        when(() => firestoreRepository.getRestaurantData(groupID))
            .thenAnswer((_) async => const <Restaurant>[]);
      });

      group(
        "loadRestaurants",
        () {
          RestaurantState initialState = const RestaurantState();

          RestaurantState loadingState =
              initialState.copyWith(status: RestaurantStatus.loading);
          RestaurantState successfulState = initialState
              .copyWith(restaurants: [], status: RestaurantStatus.success);

          blocTest<RestaurantCubit, RestaurantState>(
            'emits successful status with restaurants when loadRestaurants added',
            build: () => RestaurantCubit(firestoreRepository),
            act: (cubit) => cubit.loadRestaurants(groupID),
            verify: (_) {
              verify(() => firestoreRepository.getRestaurantData(groupID))
                  .called(1);
            },
            expect: () => <RestaurantState>[loadingState, successfulState],
          );
        },
      );

      group(
        "form fields",
        () {
          RestaurantState initialState = const RestaurantState();

          RestaurantName name = const RestaurantName.dirty(value: 'name');
          RestaurantPrice price = const RestaurantPrice.dirty(value: 1);
          RestaurantDescription description =
              const RestaurantDescription.dirty(value: 'description');
          RestaurantTags tags = const RestaurantTags.dirty(value: []);
          GroupsList groups = const GroupsList.dirty(
              value: [Group(id: 'id', name: 'name', members: [])]);

          RestaurantState nameState = initialState.copyWith(
              name: name, formStatus: FormzStatus.invalid);

          RestaurantState priceState = initialState.copyWith(
              name: name, price: price, formStatus: FormzStatus.invalid);

          RestaurantState descriptionState = initialState.copyWith(
              name: name,
              price: price,
              description: description,
              formStatus: FormzStatus.invalid);

          RestaurantState tagsState = initialState.copyWith(
              name: name,
              price: price,
              description: description,
              tags: tags,
              formStatus: FormzStatus.invalid);

          RestaurantState validState = initialState.copyWith(
              name: name,
              price: price,
              description: description,
              tags: tags,
              groups: groups,
              formStatus: FormzStatus.valid);

          blocTest<RestaurantCubit, RestaurantState>(
            'formStatus valid when all fields filled',
            build: () => RestaurantCubit(firestoreRepository),
            act: (cubit) {
              cubit.nameChanged(name.value);
              cubit.priceChanged(price.value);
              cubit.descriptionChanged(description.value);
              cubit.tagsChanged(tags.value);
              cubit.groupsChanged(groups.value);
            },
            expect: () => <RestaurantState>[
              nameState,
              priceState,
              descriptionState,
              tagsState,
              validState
            ],
          );
        },
      );
    },
  );
}
