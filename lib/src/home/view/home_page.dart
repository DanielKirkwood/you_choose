import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:you_choose/src/add/add.dart';
import 'package:you_choose/src/group/group.dart';
import 'package:you_choose/src/home/home.dart';
import 'package:you_choose/src/profile/profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: HomePage());

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selected = 0;

  final screens = [
    const AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: GroupPage(),
    ),
    const AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: AddPage(),
    ),
    const AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: ProfilePage(),
    ),
  ];

  void _onTap(int value) {
    setState(() {
      _selected = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_selected],

      bottomNavigationBar:
          BottomNavigation(currentIndex: _selected, onTap: _onTap),
    );
  }
}
