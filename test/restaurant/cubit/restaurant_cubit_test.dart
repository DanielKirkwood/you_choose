import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:you_choose/src/data/data.dart';
import 'package:you_choose/src/repositories/repositories.dart';
import 'package:you_choose/src/restaurant/cubit/restaurant_cubit.dart';
import 'package:you_choose/src/util/form_inputs/form_inputs.dart';

String groupID = 'test123';
Restaurant restaurant =
    Restaurant(name: 'test', price: 1, description: 'test description');

class MockFirestoreRepository extends Mock implements FirestoreRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(restaurant);
  });
  group(
    "RestaurantCubit",
    () {
      late FirestoreRepository firestoreRepository;
      late RestaurantName name;
      late RestaurantPrice price;
      late RestaurantDescription description;
      late RestaurantTags tags;
      late GroupsList groups;

      setUp(() {
        firestoreRepository = MockFirestoreRepository();

        when(() => firestoreRepository.getRestaurantData(groupID))
            .thenAnswer((_) async => const <Restaurant>[]);

        when(() => firestoreRepository.addRestaurant(
            restaurant: any(named: 'restaurant'),
            groups: any(named: 'groups'))).thenAnswer((_) async {});
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
        "addRestaurant",
        () {
          RestaurantState initialState = const RestaurantState();

          const name = RestaurantName.dirty(value: 'name');
          const price = RestaurantPrice.dirty(value: 1);
          const description = RestaurantDescription.dirty(value: 'description');
          const tags = RestaurantTags.dirty(value: []);
          const groups = GroupsList.dirty(
              value: [Group(id: 'id', name: 'name', members: [])]);

          Restaurant restaurant = Restaurant(
              name: name.value,
              price: price.value,
              description: description.value,
              tags: tags.value);

          RestaurantState validState = RestaurantState(
              restaurants: [restaurant],
              name: name,
              price: price,
              description: description,
              tags: tags,
              groups: groups,
              formStatus: FormzStatus.submissionInProgress);

          blocTest<RestaurantCubit, RestaurantState>(
            'emits [MyState] when MyEvent is added.',
            build: () => RestaurantCubit(firestoreRepository),
            seed: () => validState,
            act: (cubit) => cubit.addRestaurant(),
            expect: () => <RestaurantState>[
              validState.copyWith(formStatus: FormzStatus.submissionSuccess)
            ],
          );
        },
      );

      group(
        "check form fields changed functions",
        () {
          const name = RestaurantName.dirty(value: 'name');
          const price = RestaurantPrice.dirty(value: 1);
          const description = RestaurantDescription.dirty(value: 'description');
          const tags = RestaurantTags.dirty(value: []);
          const groups = GroupsList.dirty(
              value: [Group(id: 'id', name: 'name', members: [])]);

          RestaurantState initialState = const RestaurantState();

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
