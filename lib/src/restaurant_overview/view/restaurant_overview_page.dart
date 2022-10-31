import 'package:firestore_repository/firestore_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:you_choose/src/group/widgets/widgets.dart';
import 'package:you_choose/src/restaurant/restaurant.dart';
import 'package:you_choose/src/restaurant_overview/restaurants_overview.dart';
import 'package:you_choose/src/widgets/top_header.dart';

class RestaurantsOverviewPage extends StatelessWidget {
  const RestaurantsOverviewPage({super.key, required this.groupID});

  final String groupID;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RestaurantsOverviewBloc(
        restaurantRepository: RestaurantRepository(),
      )..add(RestaurantOverviewSubscriptionRequested(groupID)),
      child: RestaurantsOverviewView(
        groupID: groupID,
      ),
    );
  }
}

class RestaurantsOverviewView extends StatelessWidget {
  const RestaurantsOverviewView({super.key, required this.groupID});

  final String groupID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: BlocConsumer<RestaurantsOverviewBloc, RestaurantsOverviewState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == RestaurantOverviewStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('There was an error loading restaurants'),
                ),
              );
          }
        },
        builder: (context, state) {
          if (state.restaurants.isEmpty) {
            if (state.status == RestaurantOverviewStatus.loading) {
              return const Center(child: CupertinoActivityIndicator());
            } else if (state.status != RestaurantOverviewStatus.success) {
              return const SizedBox();
            } else {
              return Center(
                child: Text(
                  'No restaurants',
                  style: Theme.of(context).textTheme.caption,
                ),
              );
            }
          }

          return ListView(
            children: [
              TopHeader(
                title: 'Restaurants',
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<AddRestaurantPage>(
                      builder: (context) {
                        return AddRestaurantPage(groupID: groupID);
                      },
                    ),
                  );
                },
              ),
              const SearchBar(),
              for (final restaurant in state.filteredRestaurant)
                RestaurantCard(
                  name: restaurant.name,
                  price: restaurant.price,
                  description: restaurant.description,
                  tags: restaurant.tags ?? [],
                )
            ],
          );
        },
      ),
    );
  }
}
