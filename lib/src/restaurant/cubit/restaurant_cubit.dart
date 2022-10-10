import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:you_choose/src/data/data.dart';
import 'package:you_choose/src/repositories/database/firestore_repository.dart';
import 'package:you_choose/src/util/form_inputs/form_inputs.dart';

part 'restaurant_state.dart';

class RestaurantCubit extends Cubit<RestaurantState> {
  RestaurantCubit(this._firestoreRepository) : super(const RestaurantState());

  final FirestoreRepository _firestoreRepository;

  Future<void> loadRestaurants(String groupID) async {
    emit(state.copyWith(status: RestaurantStatus.loading));

    List<Restaurant> restaurants =
        await _firestoreRepository.getRestaurantData(groupID);

    emit(state.copyWith(
        status: RestaurantStatus.success, restaurants: restaurants));
  }

  Future<void> addRestaurant(String groupID) async {
    if (!state.formStatus.isValidated) return;

    emit(state.copyWith(formStatus: FormzStatus.submissionInProgress));

    try {
      Restaurant restaurant = Restaurant(
          name: state.name.value,
          price: state.price.value,
          description: state.description.value,
          tags: state.tags.value);

      await _firestoreRepository.addRestaurant(
          restaurant: restaurant, groups: state.groups.value);

      emit(state.copyWith(
          formStatus: FormzStatus.submissionSuccess,
          restaurants: [restaurant, ...state.restaurants]));
    } catch (_) {
      emit(state.copyWith(formStatus: FormzStatus.submissionFailure));
    }
  }
}
