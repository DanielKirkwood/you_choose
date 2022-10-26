import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firestore_repository/firestore_repository.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:models/models.dart';

part 'restaurant_state.dart';

class RestaurantCubit extends Cubit<RestaurantState> {
  RestaurantCubit(this._restaurantRepository) : super(const RestaurantState());

  final RestaurantRepository _restaurantRepository;

  Future<void> loadRestaurants(String groupID) async {
    emit(state.copyWith(status: RestaurantStatus.loading));

    final restaurants =
        await _restaurantRepository.getRestaurantData(groupID: groupID);

    emit(state.copyWith(
        status: RestaurantStatus.success,
        restaurants: restaurants,
      ),
    );
  }

  Future<void> addRestaurant() async {
    if (!state.formStatus.isValidated) return;

    emit(state.copyWith(formStatus: FormzStatus.submissionInProgress));

    try {
      final restaurant = Restaurant(
          name: state.name.value,
          price: state.price.value,
          description: state.description.value,
        tags: state.tags.value,
      );

      await _restaurantRepository.addRestaurant(
        restaurant: restaurant,
        groups: state.groups.value,
      );

      emit(state.copyWith(
          formStatus: FormzStatus.submissionSuccess,
          restaurants: [restaurant, ...state.restaurants],
        ),
      );
    } catch (_) {
      emit(state.copyWith(formStatus: FormzStatus.submissionFailure));
    }
  }

  void nameChanged(String value) {
    final name = RestaurantName.dirty(value: value);
    emit(state.copyWith(
      name: name,
      formStatus: Formz.validate(
          [name, state.price, state.description, state.tags, state.groups],
        ),
      ),
    );
  }

  void priceChanged(int value) {
    final price = RestaurantPrice.dirty(value: value);
    emit(state.copyWith(
      price: price,
      formStatus: Formz.validate(
          [state.name, price, state.description, state.tags, state.groups],
        ),
      ),
    );
  }

  void descriptionChanged(String value) {
    final description = RestaurantDescription.dirty(value: value);
    emit(state.copyWith(
      description: description,
      formStatus: Formz.validate(
          [state.name, state.price, description, state.tags, state.groups],
        ),
      ),
    );
  }

  void tagsChanged(List<Tag> value) {
    final tags = RestaurantTags.dirty(value: value);
    emit(state.copyWith(
      tags: tags,
      formStatus: Formz.validate(
          [state.name, state.price, state.description, tags, state.groups],
        ),
      ),
    );
  }

  void groupsChanged(List<Group> value) {
    final groups = GroupsList.dirty(value: value);
    emit(state.copyWith(
      groups: groups,
      formStatus: Formz.validate(
          [state.name, state.price, state.description, state.tags, groups],
        ),
      ),
    );
  }
}
