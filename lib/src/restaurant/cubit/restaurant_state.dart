part of 'restaurant_cubit.dart';

/// enum representing the states which the [RestaurantCubit] can be in.
///
/// [initial] - is the base state.
///
/// [loading] - intermediate state used while [RestaurantCubit] interacts
/// with backend.
///
/// [success] - action carried out successfully and state has been updated
/// with changes.
///
/// [failure] - action has failed.
enum RestaurantStatus { initial, loading, success, failure }

/// {@template restaurantState}
/// A single state used to hold state about groups.
///
/// Contains the [status] of the state and the list of [Restaurant]s
/// for frontend.
/// {@endtemplate}
class RestaurantState extends Equatable {
  /// {@macro restaurantState}
  const RestaurantState({
    this.restaurants = const <Restaurant>[],
    this.status = RestaurantStatus.initial,
    this.name = const RestaurantName.pure(),
    this.price = const RestaurantPrice.pure(),
    this.description = const RestaurantDescription.pure(),
    this.tags = const RestaurantTags.pure(),
    this.groups = const GroupsList.pure(),
    this.formStatus = FormzStatus.pure,
    this.errorMessage,
    this.priceFilters = const <int>[],
    this.tagFilters = const <Tag>[],
    this.filteredRestaurants,
  });

  /// the list of restaurants.
  final List<Restaurant> restaurants;

  final List<int> priceFilters;
  final List<Tag> tagFilters;
  final List<Restaurant>? filteredRestaurants;


  /// the status of the cubit.
  final RestaurantStatus status;

  final RestaurantName name;

  final RestaurantPrice price;

  final RestaurantDescription description;

  final RestaurantTags tags;

  final GroupsList groups;

  final FormzStatus formStatus;

  final String? errorMessage;

  RestaurantState copyWith({
    List<Restaurant>? restaurants,
    RestaurantStatus? status,
    RestaurantName? name,
    RestaurantPrice? price,
    RestaurantDescription? description,
    RestaurantTags? tags,
    GroupsList? groups,
    FormzStatus? formStatus,
    String? errorMessage,
    List<int>? priceFilters,
    List<Tag>? tagFilters,
    List<Restaurant>? filteredRestaurants,
  }) {
    return RestaurantState(
        restaurants: restaurants ?? this.restaurants,
        status: status ?? this.status,
        name: name ?? this.name,
        price: price ?? this.price,
        description: description ?? this.description,
        tags: tags ?? this.tags,
        groups: groups ?? this.groups,
        formStatus: formStatus ?? this.formStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      priceFilters: priceFilters ?? this.priceFilters,
      tagFilters: tagFilters ?? this.tagFilters,
      filteredRestaurants: filteredRestaurants ?? this.filteredRestaurants,
    );
  }

  @override
  List<Object> get props =>
      [restaurants, status, name, price, description, tags, groups, formStatus];
}
