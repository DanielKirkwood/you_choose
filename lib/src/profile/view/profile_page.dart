import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:you_choose/src/app/app.dart';
import 'package:you_choose/src/data/data.dart';
import 'package:you_choose/src/profile/profile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: ProfilePage());

  @override
  Widget build(BuildContext context) {
    UserModel user = context.select((AppBloc bloc) => bloc.state.user);
    return Scaffold(
        appBar: buildAppBar(context: context, hasBackButton: false),
        body: Stack(children: [
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            physics: const BouncingScrollPhysics(),
            children: [
              AvatarProfile(
                uid: user.uid,
                useDefault: user.useDefaultProfileImage,
                onClicked: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const EditProfilePage()),
                  );
                },
              ),
              const SizedBox(height: 24),
              buildName(user),
              const SizedBox(height: 24),
              buildFriends(user),
            ],
          ),
          Positioned(
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: TextButton(
                  onPressed: () =>
                      context.read<AppBloc>().add(AppLogoutRequested()),
                  child: const Text(
                    'Sign Out',
                    style: TextStyle(color: Colors.red),
                  )),
            ),
          ),
        ]));
  }

  Widget buildName(UserModel user) => Column(
        children: [
          Text(
            user.username,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: const TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget buildFriends(UserModel user) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Friends',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Test',
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );
}
