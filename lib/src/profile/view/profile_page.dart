import 'package:firestore_repository/firestore_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:you_choose/src/app/app.dart';
import 'package:you_choose/src/friends/cubit/friends_cubit.dart';
import 'package:you_choose/src/profile/profile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: ProfilePage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context: context, hasBackButton: false),
      body: BlocProvider(
        create: (context) => FriendsCubit(FriendRepository()),
        child: const ProfileView(),
      ),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      physics: const BouncingScrollPhysics(),
      children: [
        AvatarProfile(
          username: user.username,
          onClicked: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => const EditProfilePage(),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        BuildName(
          username: user.username,
          email: user.email,
        ),
        const SizedBox(height: 24),
        Center(
          child: TextButton(
            onPressed: () => context.read<AppBloc>().add(AppLogoutRequested()),
            child: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ),
        const SizedBox(height: 24),
        BuildFriends(
          friends: user.friends,
        )
      ],
    );
  }
}

class BuildName extends StatelessWidget {
  const BuildName({super.key, required this.username, required this.email});

  final String username;

  final String email;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          username,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(height: 4),
        Text(
          email,
          style: const TextStyle(color: Colors.grey),
        )
      ],
    );
  }
}

class BuildFriends extends StatelessWidget {
  const BuildFriends({super.key, required this.friends});

  final Map<String, dynamic> friends;

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    final friendsCubit = BlocProvider.of<FriendsCubit>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Friends',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...friends.entries.map((friend) {
          return ListTile(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (_) {
                  return BlocProvider.value(
                    value: friendsCubit,
                    child: Wrap(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            '${friend.value['username']}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                          child: ListTile(
                            onTap: () =>
                                context.read<FriendsCubit>().removeFriend(
                                      username: user.username,
                                      friendUsername: friend.key,
                                    ),
                            leading: const Icon(
                              Icons.remove,
                              color: Colors.red,
                            ),
                            title: const Text('Remove friend'),
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            },
            leading: const CircleAvatar(backgroundColor: Colors.black),
            title: Text('${friend.value['username']}'),
            trailing: const Icon(Icons.arrow_forward_ios),
          );
        }).toList()
      ],
    );
  }
}
