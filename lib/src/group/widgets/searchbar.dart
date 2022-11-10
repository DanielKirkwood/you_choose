import 'package:firestore_repository/firestore_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:you_choose/src/restaurant_overview/restaurants_overview.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({super.key, required this.openDrawer});

  final void Function() openDrawer;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RestaurantsOverviewBloc(
        restaurantRepository: RestaurantRepository(),
      ),
      child: SearchBarField(
        openDrawer: openDrawer,
      ),
    );
  }
}

class SearchBarField extends StatelessWidget {
  const SearchBarField({super.key, required this.openDrawer});

  final void Function() openDrawer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child:
                BlocBuilder<RestaurantsOverviewBloc, RestaurantsOverviewState>(
              buildWhen: (previous, current) =>
                  previous.searchTerm != current.searchTerm,
              builder: (context, state) {
                return TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Where do you want to eat?',
                    suffixIcon: Icon(
                      Icons.search,
                      color: Theme.of(context).primaryColor,
                    ),
                    contentPadding:
                        const EdgeInsets.only(left: 20, bottom: 5, top: 5),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {

                    context.read<RestaurantsOverviewBloc>().add(
                          RestaurantOverviewSearchTermChanged(value),
                        );
                  },
                );
              },
            ),
          ),
          const SizedBox(
            width: 30,
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: IconButton(
              onPressed: openDrawer,
              icon: Icon(
                Icons.menu,
                color: Theme.of(context).primaryColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
