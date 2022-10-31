import 'package:firestore_repository/firestore_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:you_choose/src/profile/profile.dart';
import 'package:you_choose/src/restaurant/cubit/restaurant_cubit.dart';
import 'package:you_choose/src/tag/cubit/tag_cubit.dart';
import 'package:you_choose/src/util/constants/constants.dart';

class FilterPage extends StatelessWidget {
  const FilterPage({super.key, required this.groupID});

  final String groupID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          buildAppBar(context: context, hasBackButton: true, title: 'Filter'),
      backgroundColor: Theme.of(context).backgroundColor,
      body: MultiBlocProvider(
        providers: [
          BlocProvider<TagCubit>(
            create: (context) => TagCubit(GroupRepository()),
          ),
          BlocProvider<RestaurantCubit>(
            create: (context) => RestaurantCubit(RestaurantRepository()),
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Price', style: Theme.of(context).textTheme.headline4),
              const BuildPriceFilters(prices: [1, 2, 3, 4]),
              Text('Tag', style: Theme.of(context).textTheme.headline4),
              BuildTagFilter(
                groupID: groupID,
              ),
            ],
          ),
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
    return BlocBuilder<RestaurantCubit, RestaurantState>(
      builder: (context, state) {
        return Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: 20,
          children: prices
              .map(
                (price) => InkWell(
                  onTap: () {
                    if (state.priceFilters.contains(price)) {
                      final newList =
                          state.priceFilters.where((x) => x != price).toList();
                      context
                          .read<RestaurantCubit>()
                          .priceFilterChanged(newList);
                    } else {
                      context
                          .read<RestaurantCubit>()
                          .priceFilterChanged([...state.priceFilters, price]);
                    }
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
                      color: state.priceFilters.contains(price)
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
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      state.tags[index].name,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    SizedBox(
                      height: 25,
                      child: Checkbox(
                        value: false,
                        onChanged: (bool? newValue) {},
                      ),
                    )
                  ],
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
