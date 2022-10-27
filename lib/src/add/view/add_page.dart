import 'package:flutter/material.dart';
import 'package:you_choose/src/add/add.dart';
import 'package:you_choose/src/friends/friends.dart';
import 'package:you_choose/src/group/group.dart';
import 'package:you_choose/src/profile/profile.dart';
import 'package:you_choose/src/restaurant/view/add_restaurant_page.dart';
import 'package:you_choose/src/tag/tag.dart';

class AddPage extends StatelessWidget {
  const AddPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: AddPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context: context, hasBackButton: false),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Heading(title: 'Something New?'),
            const SizedBox(
              height: 20,
            ),
            ButtonLink(
              title: 'Add Group',
              subTitle: 'Create the perfect team of hungry friends',
              screen: const AddGroupPage(),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => const AddGroupPage(),
                  ),
                );
              },
            ),
            ButtonLink(
              title: 'Add Restaurant',
              subTitle: 'Save a new spot',
              screen: const AddRestaurantPage(
                groupID: '1',
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddRestaurantPage(
                              groupID: '1',
                    ),
                  ),
                );
              },
            ),
            ButtonLink(
              title: 'Add Tag',
              subTitle: 'Get organised',
              screen: const AddGroupPage(),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => const AddTagPage(),
                  ),
                );
              },
            ),
            ButtonLink(
              title: 'Add Friend',
              subTitle: 'Find your friends',
              screen: const AddFriendPage(),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => const AddFriendPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Heading extends StatelessWidget {
  const Heading({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 45,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  color: Color.fromARGB(225, 14, 20, 69),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
