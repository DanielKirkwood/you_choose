import 'package:firestore_repository/firestore_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:you_choose/src/app/app.dart';
import 'package:you_choose/src/profile/cubit/profile_cubit.dart';
import 'package:you_choose/src/profile/widgets/widgets.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  static Page<void> page() =>
      const MaterialPage<void>(child: EditProfilePage());

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    final firebaseApp =
        context.select((AppBloc bloc) => bloc.state.firebaseApp);

    return Scaffold(
      appBar: buildAppBar(context: context, hasBackButton: true),
      body: BlocProvider(
        create: (BuildContext context) =>
            ProfileCubit(StorageRepository(firebaseApp: firebaseApp))
          ..getProfileUrl(username: user.username),
        child: const EditProfileView(),
      ),
    );
  }
}

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          physics: const BouncingScrollPhysics(),
          children: [
            _BuildAvatarImage(
              username: user.username,
            ),
          ],
        )
      ],
    );
  }
}

class _BuildAvatarImage extends StatelessWidget {
  const _BuildAvatarImage({required this.username});

  final String username;

  Future<XFile?> _pickImage() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);

      return image;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state.imageURL != null) {
          AvatarProfile(
            username: username,
            url: state.imageURL!,
            onClicked: () async {
              final image = await _pickImage();
            },
          );
        }
        return Container();
      },
    );
  }
}
