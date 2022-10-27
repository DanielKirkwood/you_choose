import 'package:firestore_repository/firestore_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:you_choose/src/app/app.dart';
import 'package:you_choose/src/friends/cubit/friends_cubit.dart';
import 'package:you_choose/src/profile/cubit/profile_cubit.dart';
import 'package:you_choose/src/profile/profile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: ProfilePage());

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    final firebaseApp =
        context.select((AppBloc bloc) => bloc.state.firebaseApp);
    return Scaffold(
      appBar: buildAppBar(context: context, hasBackButton: false),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<ProfileCubit>(
            create: (BuildContext context) =>
                ProfileCubit(StorageRepository(firebaseApp: firebaseApp))
              ..getProfileUrl(
                username: user.username,
              ),
          ),
          BlocProvider<FriendsCubit>(
            create: (BuildContext context) => FriendsCubit(FriendRepository()),
          ),
        ],
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
        _BuildAvatarImage(
          username: user.username,
        ),
        const SizedBox(height: 24),
        _BuildName(
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
        _BuildFriends(
          friends: user.friends,
        )
      ],
    );
  }
}

class _BuildAvatarImage extends StatelessWidget {
  const _BuildAvatarImage({required this.username});

  final String username;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state.imageURL != null) {
          AvatarProfile(
            username: username,
            url: state.imageURL!,
            onClicked: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => const EditProfilePage(),
                ),
              );
            },
          );
        }
        return Container();
      },
    );
  }
}

class _BuildName extends StatelessWidget {
  const _BuildName({required this.username, required this.email});

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

class _BuildFriends extends StatelessWidget {
  const _BuildFriends({required this.friends});

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
                            friend.key,
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
            title: Text(friend.key),
            trailing: const Icon(Icons.arrow_forward_ios),
          );
        }).toList()
      ],
    );
  }
}
