import 'package:firestore_repository/firestore_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:you_choose/src/restaurant_overview/restaurants_overview.dart';
import 'package:you_choose/src/tag/cubit/tag_cubit.dart';
import 'package:you_choose/src/util/constants/constants.dart';

class FilterDrawer extends StatelessWidget {
  const FilterDrawer(
      {super.key, required this.groupID, required this.closeDrawer});

  final String groupID;
  final void Function() closeDrawer;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BlocProvider<TagCubit>(
        create: (context) => TagCubit(GroupRepository()),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
              height: 120,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: Text(
                  'Filter',
                  style: Theme.of(context)
                      .textTheme
                      .headline2!
                      .merge(const TextStyle(color: Colors.white)),
                ),
              ),
            ),
            Column(
              children: [
                Text('Price', style: Theme.of(context).textTheme.headline4),
                const BuildPriceFilters(prices: [1, 2, 3, 4]),
                Text('Tag', style: Theme.of(context).textTheme.headline4),
                BuildTagFilter(
                  groupID: groupID,
                ),
                ElevatedButton(
                  onPressed: closeDrawer,
                  child: const Text('Close'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class BuildPriceFilters extends StatelessWidget {
  const BuildPriceFilters({super.key, required this.prices});

  final List<int> prices;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantsOverviewBloc, RestaurantsOverviewState>(
      buildWhen: (previous, current) =>
          previous.filterPrices != current.filterPrices,
      builder: (context, state) {
        return Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: 10,
          children: prices
              .map(
                (price) => InkWell(
                  onTap: () {
                    context.read<RestaurantsOverviewBloc>().add(
                          RestaurantOverviewPricesFilterToggle(price),
                        );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: state.filterPrices.contains(price)
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      '£' * price,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class BuildTagFilter extends StatelessWidget {
  const BuildTagFilter({super.key, required this.groupID});

  final String groupID;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TagCubit, TagState>(
      buildWhen: (previous, current) => previous.tags != current.tags,
      builder: (context, state) {
        if (state.status == TagStatus.initial) {
          context.read<TagCubit>().loadTags(groupID: groupID);
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == TagStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == TagStatus.failure) {
          return const Center(
            child: Text('There was an error loading tag data.'),
          );
        }
        if (state.status == TagStatus.success) {
          if (state.tags.isEmpty) {
            return const Center(
              child: Text(Constants.textNoData),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: state.tags.length,
            itemBuilder: (BuildContext context, int index) {
              final tagName = state.tags[index];
              return Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: BlocBuilder<RestaurantsOverviewBloc,
                    RestaurantsOverviewState>(
                  buildWhen: (previous, current) =>
                      previous.filterTags != current.filterTags,
                  builder: (context, state) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          tagName,
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        SizedBox(
                          height: 25,
                          child: Checkbox(
                            activeColor: Theme.of(context).primaryColor,
                            value: state.filterTags.contains(tagName),
                            onChanged: (bool? newValue) {
                              context.read<RestaurantsOverviewBloc>().add(
                                    RestaurantOverviewTagsFilterToggle(tagName),
                                  );
                            },
                          ),
                        )
                      ],
                    );
                  },
                ),
              );
            },
          );
        }
        return const Center(child: Text('An unknown error has occurred'));
      },
    );
  }
}
