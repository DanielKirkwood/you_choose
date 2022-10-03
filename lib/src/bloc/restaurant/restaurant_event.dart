part of 'restaurant_bloc.dart';

abstract class RestaurantEvent extends Equatable {
  const RestaurantEvent();

  @override
  List<Object> get props => [];
}

class LoadRestaurants extends RestaurantEvent {
  final String groupId;
  const LoadRestaurants({required this.groupId});

  @override
  List<Object> get props => [groupId];
}

class UpdateRestaurants extends RestaurantEvent {
  final List<Restaurant> restaurants;

  const UpdateRestaurants(this.restaurants);

  @override
  List<Object> get props => [restaurants];
}

class AddRestaurant extends RestaurantEvent {
  final Restaurant restaurant;
  final List<Group> groups;

  const AddRestaurant({required this.restaurant, required this.groups});

  @override
  List<Object> get props => [restaurant, groups];
}

class DeleteRestaurant extends RestaurantEvent {
  final Restaurant restaurant;
  final List<Group> group;

  const DeleteRestaurant({required this.restaurant, required this.group});

  @override
  List<Object> get props => [restaurant];
}
