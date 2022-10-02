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

  const RestaurantsLoaded({required this.restaurants});

  @override
  List<Object> get props => [restaurants];
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
