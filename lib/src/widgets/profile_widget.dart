import 'package:cached_firestorage/lib.dart';
import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  final String uid;
  final VoidCallback onClicked;
  final bool isEdit;
  final bool useDefault;

  const ProfileWidget({
    Key? key,
    required this.uid,
    required this.onClicked,
    this.isEdit = false,
    this.useDefault = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(
        children: [
          buildImage(),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(color),
          ),
        ],
      ),
    );
  }

  Widget buildImage() {
    return InkWell(
      onTap: onClicked,
      child: RemotePicture(
          imagePath: useDefault
              ? "user/profile/default_profile.jpg"
              : "user/profile/$uid.jpg",
          mapKey: uid,
          useAvatarView: true,
          avatarViewRadius: 60,
          fit: BoxFit.cover),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: Icon(
            isEdit ? Icons.add_a_photo : Icons.edit,
            color: Colors.white,
            size: 20,
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
