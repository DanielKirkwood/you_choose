import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

/// {@template restaurantFilter}
/// A single restaurant filter status.
/// {@endtemplate}
class RestaurantFilter extends Equatable {
  /// {@macro restaurantFilter}
  const RestaurantFilter({
    required this.name,
    required this.restaurant,
    required this.value,
  });

  /// the name of the Restaurant.
  final String name;

  /// the [Restaurant] object.
  final Restaurant restaurant;

  /// the value
  final bool value;

  /// convenience copyWith method.
  RestaurantFilter copyWith({
    String? name,
    Restaurant? restaurant,
    bool? value,
  }) {
    return RestaurantFilter(
      name: name ?? this.name,
      restaurant: restaurant ?? this.restaurant,
      value: value ?? this.value,
    );
  }

  /// created a list of filters from a given list of Restaurants.
  static List<RestaurantFilter> getFilters(List<Restaurant> restaurants) {
    return restaurants
        .map(
          (restaurant) => RestaurantFilter(
            name: restaurant.name,
            restaurant: restaurant,
            value: false,
          ),
        )
        .toList();
  }

  @override
  List<Object?> get props => [name, restaurant, value];
}
