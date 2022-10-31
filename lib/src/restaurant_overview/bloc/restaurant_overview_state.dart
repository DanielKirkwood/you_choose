part of 'restaurant_overview_bloc.dart';

enum RestaurantOverviewStatus { initial, loading, success, failure }

class RestaurantsOverviewState extends Equatable {
  const RestaurantsOverviewState(
      {this.status = RestaurantOverviewStatus.initial,
      this.restaurants = const <Restaurant>[],
      this.filter = RestaurantViewFilter.all});

  final RestaurantOverviewStatus status;
  final List<Restaurant> restaurants;
  final RestaurantViewFilter filter;

  Iterable<Restaurant> get filteredRestaurant => filter.applyAll(restaurants);

  RestaurantsOverviewState copyWith({
    RestaurantOverviewStatus Function()? status,
    List<Restaurant> Function()? restaurants,
    RestaurantViewFilter Function()? filter,
  }) {
    return RestaurantsOverviewState(
      status: status != null ? status() : this.status,
      restaurants: restaurants != null ? restaurants() : this.restaurants,
      filter: filter != null ? filter() : this.filter,
    );
  }

  @override
  List<Object?> get props => [status, restaurants];
}
