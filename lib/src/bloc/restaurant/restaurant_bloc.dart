import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:you_choose/src/models/models.dart';
import 'package:you_choose/src/repositories/repositories.dart';

part 'restaurant_event.dart';
part 'restaurant_state.dart';

class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  final FirestoreRepository _dbRepository;
  RestaurantBloc(this._dbRepository) : super(RestaurantInitial()) {
    on<LoadRestaurants>(_onLoadRestaurants);
    on<AddRestaurant>(_onAddRestaurant);
  }

  _onLoadRestaurants(LoadRestaurants event, Emitter emit) async {
    try {
      List<Restaurant> restaurants =
          await _dbRepository.getRestaurantData(event.groupId);
      emit(RestaurantsLoaded(restaurants: restaurants));
    } catch (e) {
      emit(const RestaurantError(
          message: 'There was an error loading the restaurants"'));
    }
  }

  _onAddRestaurant(AddRestaurant event, Emitter emit) async {
    try {
      await _dbRepository.addRestaurant(event.restaurant, event.groups);
      emit(RestaurantAdded(newRestaurant: event.restaurant));
    } catch (e) {
      emit(RestaurantError(
          message: 'There was an error adding "${event.restaurant.name}"'));
    }
  }
}
