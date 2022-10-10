import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:you_choose/src/data/data.dart';
import 'package:you_choose/src/repositories/database/firestore_repository.dart';

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
}
