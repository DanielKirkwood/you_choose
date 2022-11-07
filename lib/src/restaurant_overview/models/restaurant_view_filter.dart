import 'package:models/models.dart';

class RestaurantViewFilter {
  static bool apply(
    Restaurant restaurant,
    String searchTerm,
    List<String> tags,
    List<int> prices,
  ) {
    // search term not found in restaurant name
    if (!restaurant.name.toLowerCase().contains(searchTerm.toLowerCase())) {
      return false;
    }

    // if restaurant has no tags and user wants specific tag
    // then this restaurant does not satisfy need
    if (restaurant.tags == null && tags.isNotEmpty) return false;

    // if no filters given, restaurant passes
    if (tags.isEmpty && prices.isEmpty) return true;

    // if no tag filters then just use price
    if (tags.isEmpty) return prices.contains(restaurant.price);

    // if no price filters, only use restaurants
    if (prices.isEmpty) {
      if (restaurant.tags != null) {
        return restaurant.tags!.any((x) => tags.contains(x));
      }
    }

    // if both filters given
    final tagCheck = restaurant.tags!.any((x) => tags.contains(x));
    final priceCheck = prices.contains(restaurant.price);

    return tagCheck && priceCheck;
  }

  static Iterable<Restaurant> applyAll(
    Iterable<Restaurant> restaurants,
    String searchTerm,
    List<String> tags,
    List<int> prices,
  ) {
    return restaurants.where((restaurant) => apply(
          restaurant,
          searchTerm,
          tags,
          prices,
        ));
  }
}
