part of 'restaurant_bloc.dart';

abstract class RestaurantState extends Equatable {
  const RestaurantState();

  @override
  List<Object> get props => [];
}

class RestaurantInitial extends RestaurantState {
  @override
  List<Object> get props => [];
}

class RestaurantLoading extends RestaurantState {
  @override
  List<Object> get props => [];
}

class RestaurantsLoaded extends RestaurantState {
  final List<Restaurant> restaurants;
  final String groupID;

  const RestaurantsLoaded({required this.restaurants, required this.groupID});

  @override
  List<Object> get props => [restaurants, groupID];
}

class RestaurantAdded extends RestaurantState {
  final Restaurant newRestaurant;

  const RestaurantAdded({required this.newRestaurant});

  @override
  List<Object> get props => [newRestaurant];
}

class RestaurantDeleted extends RestaurantState {
  final Restaurant restaurant;

  const RestaurantDeleted({required this.restaurant});

  @override
  List<Object> get props => [restaurant];
}

class RestaurantError extends RestaurantState {
  final String message;

  const RestaurantError({this.message = ''});

  @override
  List<Object> get props => [message];
}
