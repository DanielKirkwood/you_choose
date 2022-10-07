import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:you_choose/src/bloc/authentication/authentication_bloc.dart';
import 'package:you_choose/src/models/models.dart';
import 'package:you_choose/src/screens/edit_profile_screen.dart';
import 'package:you_choose/src/widgets/appbar_widget.dart';
import 'package:you_choose/src/widgets/profile_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationSuccess) {

            return Stack(children: [
              ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  ProfileWidget(
                    uid: state.user!.uid!,
                    imagePath:
                        state.user!.profileImage!,
                    onClicked: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const EditProfileScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  buildName(state.user!),
                  const SizedBox(height: 24),
                  buildFriends(state.user!),
                ],
              ),
              Positioned(
                bottom: 0,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: TextButton(
                      onPressed: () =>
                          BlocProvider.of<AuthenticationBloc>(context)
                              .add(AuthenticationSignedOut()),
                      child: const Text(
                        'Sign Out',
                        style: TextStyle(color: Colors.red),
                      )),
                ),
              ),
            ]);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget buildName(UserModel user) => Column(
        children: [
          Text(
            user.username!,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            user.email!,
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
