import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:you_choose/src/group/cubit/group_cubit.dart';
import 'package:you_choose/src/group/view/view.dart';
import 'package:you_choose/src/repositories/database/firestore_repository.dart';

import '../../profile/widgets/widgets.dart';

class AddGroupPage extends StatelessWidget {
  const AddGroupPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: AddGroupPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context: context, hasBackButton: true),
      body: BlocProvider(
        create: (context) => GroupCubit(FirestoreRepository()),
        child: const AddGroupForm(),
      ),
    );
  }
}
