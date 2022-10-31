import 'package:models/models.dart';

enum RestaurantViewFilter { all, unvisited, visited }

extension RestaurantViewFilterX on RestaurantViewFilter {
  bool apply(Restaurant restaurant) {
    switch (this) {
      case RestaurantViewFilter.all:
        return true;
      case RestaurantViewFilter.unvisited:
        return false;
      case RestaurantViewFilter.visited:
        return false;
    }
  }

  Iterable<Restaurant> applyAll(Iterable<Restaurant> restaurants) {
    return restaurants.where(apply);
  }
}
