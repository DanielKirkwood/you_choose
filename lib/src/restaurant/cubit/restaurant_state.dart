part of 'restaurant_cubit.dart';

/// enum representing the states which the [RestaurantCubit] can be in.
///
/// [initial] - is the base state.
///
/// [loading] - intermediate state used while [RestaurantCubit] interacts with backend.
///
/// [success] - action carried out successfully and state has been updated with changes.
///
/// [failure] - action has failed.
enum RestaurantStatus { initial, loading, success, failure }

/// {@template restaurantState}
/// A single state used to hold state about groups.
///
/// Contains the [status] of the state and the list of [Restaurant]s for frontend.
/// {@endtemplate}
class RestaurantState extends Equatable {
  /// {@macro restaurantState}
  const RestaurantState(
      {this.restaurants = const <Restaurant>[],
      this.status = RestaurantStatus.initial});

  /// the list of restaurants.
  final List<Restaurant> restaurants;

  /// the status of the cubit.
  final RestaurantStatus status;

  RestaurantState copyWith(
      {List<Restaurant>? restaurants, RestaurantStatus? status}) {
    return RestaurantState(
        restaurants: restaurants ?? this.restaurants,
        status: status ?? this.status);
  }

  @override
  List<Object> get props => [restaurants, status];
}
