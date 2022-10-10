import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:you_choose/src/app/app.dart';
import 'package:you_choose/src/data/data.dart';
import 'package:you_choose/src/group/cubit/group_cubit.dart';
import 'package:you_choose/src/group/view/add_group_page.dart';
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
    UserModel user = context.select((AppBloc bloc) => bloc.state.user);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TopHeader(
          title: 'Groups',
          onPress: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const AddGroupPage();
            }));
          },
        ),
        searchBar(),
        BlocConsumer<GroupCubit, GroupState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == GroupStatus.failure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text('There was an error fetching group data.'),
                  ),
                );
            }
          },
          buildWhen: (previous, current) =>
              previous.status != current.status ||
              previous.groups != current.groups,
          builder: (context, state) {
            if (state.status == GroupStatus.initial) {
              context.read<GroupCubit>().loadGroups(user.uid);
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == GroupStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == GroupStatus.failure) {
              return const Center(
                child: Text('There was an error loading group data.'),
              );
            }
            if (state.status == GroupStatus.success) {
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
                  return GroupTile(
                    group: state.groups[index],
                    numRestaurants: 40,
                  );
                },
              );
            }
            return const Center(child: Text('An unknown error has occurred'));
          },
        ),
      ]),
    );
  }
}
