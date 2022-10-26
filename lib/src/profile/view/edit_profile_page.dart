import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:you_choose/src/app/app.dart';
import 'package:you_choose/src/profile/widgets/widgets.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  static Page<void> page() =>
      const MaterialPage<void>(child: EditProfilePage());

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
    final user = context.select((AppBloc bloc) => bloc.state.user);

    return Scaffold(
        appBar: buildAppBar(context: context, hasBackButton: true),
        body: Stack(children: [
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            physics: const BouncingScrollPhysics(),
            children: [
              AvatarProfile(
                username: user.username,
                isEdit: true,
                onClicked: () async {
                  final image = await _pickImage();
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
