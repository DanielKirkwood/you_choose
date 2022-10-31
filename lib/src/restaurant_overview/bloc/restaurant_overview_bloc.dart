import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firestore_repository/firestore_repository.dart';
import 'package:models/models.dart';
import 'package:you_choose/src/restaurant_overview/models/models.dart';

part 'restaurant_overview_event.dart';
part 'restaurant_overview_state.dart';

class RestaurantsOverviewBloc
    extends Bloc<RestaurantOverviewEvent, RestaurantsOverviewState> {
  RestaurantsOverviewBloc({
    required RestaurantRepository restaurantRepository,
  })  : _restaurantRepository = restaurantRepository,
        super(const RestaurantsOverviewState()) {
    on<RestaurantOverviewSubscriptionRequested>(_onSubscriptionRequested);
    on<RestaurantOverviewFilterChanged>(_onFilterChanged);
  }

  final RestaurantRepository _restaurantRepository;

  Future<void> _onSubscriptionRequested(
    RestaurantOverviewSubscriptionRequested event,
    Emitter<RestaurantsOverviewState> emit,
  ) async {
    emit(state.copyWith(status: () => RestaurantOverviewStatus.loading));

    await emit.forEach<List<Restaurant>>(
      _restaurantRepository.getRestaurantsStream(groupID: event.groupID),
      onData: (restaurants) => state.copyWith(
        status: () => RestaurantOverviewStatus.success,
        restaurants: () => restaurants,
      ),
      onError: (_, __) => state.copyWith(
        status: () => RestaurantOverviewStatus.failure,
      ),
    );
  }

  void _onFilterChanged(
    RestaurantOverviewFilterChanged event,
    Emitter<RestaurantsOverviewState> emit,
  ) {
    emit(state.copyWith(filter: () => event.filter));
  }
}
