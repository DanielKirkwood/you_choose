part of 'restaurant_overview_bloc.dart';

abstract class RestaurantOverviewEvent extends Equatable {
  const RestaurantOverviewEvent();

  @override
  List<Object> get props => [];
}

class RestaurantOverviewSubscriptionRequested extends RestaurantOverviewEvent {
  const RestaurantOverviewSubscriptionRequested(this.groupID);

  final String groupID;

  @override
  List<Object> get props => [groupID];
}

class RestaurantOverviewSearchTermChanged extends RestaurantOverviewEvent {
  const RestaurantOverviewSearchTermChanged(this.searchTerm);

  final String searchTerm;

  @override
  List<Object> get props => [searchTerm];
}

class RestaurantOverviewTagsFilterToggle extends RestaurantOverviewEvent {
  const RestaurantOverviewTagsFilterToggle(this.tag);

  final String tag;

  @override
  List<Object> get props => [tag];
}

class RestaurantOverviewPricesFilterToggle extends RestaurantOverviewEvent {
  const RestaurantOverviewPricesFilterToggle(this.price);

  final int price;

  @override
  List<Object> get props => [price];
}
