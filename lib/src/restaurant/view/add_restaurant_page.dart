import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:you_choose/src/group/cubit/group_cubit.dart';
import 'package:you_choose/src/profile/profile.dart';
import 'package:you_choose/src/repositories/database/firestore_repository.dart';
import 'package:you_choose/src/restaurant/cubit/restaurant_cubit.dart';
import 'package:you_choose/src/restaurant/view/view.dart';
import 'package:you_choose/src/tag/cubit/tag_cubit.dart';

class AddRestaurantPage extends StatelessWidget {
  const AddRestaurantPage({super.key, required this.groupID});

  final String groupID;

  static Page<void> page(String groupID) =>
      MaterialPage<void>(child: AddRestaurantPage(groupID: groupID));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context: context, hasBackButton: true),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<RestaurantCubit>(
            create: (BuildContext context) =>
                RestaurantCubit(FirestoreRepository()),
          ),
          BlocProvider<GroupCubit>(
            create: (BuildContext context) => GroupCubit(FirestoreRepository()),
          ),
          BlocProvider<TagCubit>(
            create: (BuildContext context) =>
                TagCubit(FirestoreRepository(), groupID),
          ),
        ],
        child: AddRestaurantForm(groupID: groupID),
      ),
    );
  }
}
