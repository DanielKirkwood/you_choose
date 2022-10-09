import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:you_choose/src/app/app.dart';
import 'package:you_choose/src/data/data.dart';
import 'package:you_choose/src/profile/widgets/widgets.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  static Page<void> page() =>
      const MaterialPage<void>(child: EditProfilePage());

  Future<XFile?> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) return null;

      return image;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel user = context.select((AppBloc bloc) => bloc.state.user);
    XFile? newImage;

    return Scaffold(
        appBar: buildAppBar(context: context, hasBackButton: true),
        body: Stack(children: [
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            physics: const BouncingScrollPhysics(),
            children: [
              AvatarProfile(
                uid: user.uid,
                isEdit: true,
                useDefault: user.useDefaultProfileImage,
                onClicked: () async {
                  XFile? image = await _pickImage();

                  if (image == null) return;

                  newImage = image;
                },
              ),
            ],
          )
        ]));
  }
}
