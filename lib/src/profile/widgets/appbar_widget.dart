import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

AppBar buildAppBar(
    {required BuildContext context, required bool hasBackButton}) {
  return AppBar(
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
          ))
    ],
  );
}
