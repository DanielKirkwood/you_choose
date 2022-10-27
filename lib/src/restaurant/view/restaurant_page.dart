import 'package:firestore_repository/firestore_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:you_choose/src/group/widgets/widgets.dart';
import 'package:you_choose/src/restaurant/cubit/restaurant_cubit.dart';
import 'package:you_choose/src/restaurant/restaurant.dart';
import 'package:you_choose/src/util/constants/constants.dart';
import 'package:you_choose/src/widgets/top_header.dart';

class RestaurantPage extends StatelessWidget {
  const RestaurantPage({super.key, required this.groupID});

  final String groupID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => RestaurantCubit(RestaurantRepository()),
        child: RestaurantView(groupID: groupID),
      ),
    );
  }
}

class RestaurantView extends StatelessWidget {
  const RestaurantView({super.key, required this.groupID});

  final String groupID;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TopHeader(
            title: 'Restaurants',
            onPress: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AddRestaurantPage(groupID: groupID);
                  },
                ),
              );
            },
          ),
          searchBar(),
          BlocConsumer<RestaurantCubit, RestaurantState>(
              listenWhen: (previous, current) =>
                  previous.status != current.status,
              listener: (context, state) {
                if (state.status == RestaurantStatus.failure) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text(
                        'There was an error fetching restaurant data.',
                      ),
                      ),
                    );
                }
              },
              buildWhen: (previous, current) =>
                  previous.status != current.status ||
                  previous.restaurants != current.restaurants,
              builder: (context, state) {
                if (state.status == RestaurantStatus.initial) {
                  context.read<RestaurantCubit>().loadRestaurants(groupID);
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.status == RestaurantStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.status == RestaurantStatus.failure) {
                  return const Center(
                    child: Text('There was an error loading restaurant data.'),
                  );
                }
                if (state.status == RestaurantStatus.success) {
                  if (state.restaurants.isEmpty) {
                    return const Center(
                      child: Text(Constants.textNoData),
                    );
                  }
                  return ListView.builder(
                    itemCount: state.restaurants.length,
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 16),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      final r = state.restaurants[index];
                      return RestaurantCard(
                        name: r.name,
                        price: r.price,
                        description: r.description,
                        tags: r.tags ?? [],
                      );
                    },
                  );
                }
                return const Center(
                child: Text('An unknown error has occurred'),
              );
            },
          )
        ],
      ),
    );
  }
}
