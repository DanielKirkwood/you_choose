import 'package:flutter/material.dart';
import 'package:you_choose/src/util/constants/constants.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final void Function(int newValue) onTap;

  const BottomNavigation(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: ((int value) {
        onTap(value);
      }),
      selectedItemColor: Constants.kDarkBlueColor,
      unselectedItemColor: Constants.kBlackColor,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.group),
          label: 'Groups',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Profile',
        ),
      ],
    );
  }
}
