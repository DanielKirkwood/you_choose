import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:you_choose/src/group/cubit/group_cubit.dart';
import 'package:you_choose/src/group/widgets/widgets.dart';
import 'package:you_choose/src/repositories/repositories.dart';
import 'package:you_choose/src/util/constants/constants.dart';
import 'package:you_choose/src/widgets/top_header.dart';

class GroupPage extends StatelessWidget {
  const GroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
      create: (_) => GroupCubit(FirestoreRepository()),
      child: const GroupView(),
    ));
  }
}

class GroupView extends StatelessWidget {
  const GroupView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TopHeader(
            title: 'Groups',
            label: 'Add Group',
            onPress: () => Navigator.pushNamed(context, '/add-group')),
        searchBar(),
        BlocConsumer<GroupCubit, GroupState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            if (state.groups.isEmpty) {
              return const Center(
                child: Text(Constants.textNoData),
              );
            }
            return ListView.builder(
              itemCount: state.groups.length,
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 16),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return GroupListTile(
                  group: state.groups[index],
                  numRestaurants: 40,
                );
              },
            );
          },
        ),
      ]),
    );
  }
}
