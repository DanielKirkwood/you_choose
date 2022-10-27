import 'package:firestore_repository/firestore_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:you_choose/src/friends/cubit/friends_cubit.dart';
import 'package:you_choose/src/friends/friends.dart';
import 'package:you_choose/src/profile/widgets/widgets.dart';

class AddFriendPage extends StatelessWidget {
  const AddFriendPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: AddFriendPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context: context, hasBackButton: true),
      body: BlocProvider(
        create: (context) => FriendsCubit(FriendRepository()),
        child: const AddFriendForm(),
      ),
    );
  }
}
