import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

AppBar buildAppBar(
    {
  required BuildContext context,
  required bool hasBackButton,
  String? title,
}) {
  return AppBar(
    title: title != null
        ? Text(
            title,
            style: Theme.of(context).textTheme.headline3,
          )
        : null,
    leading: hasBackButton
        ? const BackButton(
            color: Colors.black,
          )
        : null,
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: [
      IconButton(
          onPressed: () {},
          icon: const Icon(
            CupertinoIcons.moon_stars,
            color: Colors.black,
        ),
      )
    ],
  );
}
