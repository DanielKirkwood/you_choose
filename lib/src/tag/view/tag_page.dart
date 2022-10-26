import 'package:firestore_repository/firestore_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:you_choose/src/group/cubit/group_cubit.dart';
import 'package:you_choose/src/profile/widgets/widgets.dart';
import 'package:you_choose/src/tag/cubit/tag_cubit.dart';
import 'package:you_choose/src/tag/tag.dart';

class AddTagPage extends StatelessWidget {
  const AddTagPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: AddTagPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context: context, hasBackButton: true),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<TagCubit>(
            create: (BuildContext context) => TagCubit(GroupRepository()),
          ),
          BlocProvider<GroupCubit>(
            create: (BuildContext context) => GroupCubit(GroupRepository()),
          ),
        ],
        child: const AddTagForm(),
      ),
    );
  }
}
