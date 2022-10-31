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

class RestaurantOverviewFilterChanged extends RestaurantOverviewEvent {
  const RestaurantOverviewFilterChanged(this.filter);

  final RestaurantViewFilter filter;

  @override
  List<Object> get props => [filter];
}
