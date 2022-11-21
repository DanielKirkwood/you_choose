part of 'restaurant_overview_bloc.dart';

enum RestaurantOverviewStatus { initial, loading, success, failure }

class RestaurantsOverviewState extends Equatable {
  const RestaurantsOverviewState({
    this.status = RestaurantOverviewStatus.initial,
    this.restaurants = const <Restaurant>[],
    this.searchTerm = '',
    this.filterTags = const <String>[],
    this.filterPrices = const <int>[],
  });

  final RestaurantOverviewStatus status;
  final List<Restaurant> restaurants;
  final String searchTerm;
  final List<String> filterTags;
  final List<int> filterPrices;

  Iterable<Restaurant> get filteredRestaurants =>
      RestaurantViewFilter.applyAll(
        restaurants,
        searchTerm,
        filterTags,
        filterPrices,
      );

  RestaurantsOverviewState copyWith({
    RestaurantOverviewStatus Function()? status,
    List<Restaurant> Function()? restaurants,
    String Function()? searchTerm,
    List<String> Function()? filterTags,
    List<int> Function()? filterPrices,
  }) {
    return RestaurantsOverviewState(
      status: status != null ? status() : this.status,
      restaurants: restaurants != null ? restaurants() : this.restaurants,
      searchTerm: searchTerm != null ? searchTerm() : this.searchTerm,
      filterTags: filterTags != null ? filterTags() : this.filterTags,
      filterPrices: filterPrices != null ? filterPrices() : this.filterPrices,
    );
  }

  @override
  List<Object?> get props => [
        status,
        restaurants,
        searchTerm,
        filterTags,
        filterPrices,
      ];
}
