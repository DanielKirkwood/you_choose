import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class SpeedDialButton extends StatelessWidget {
  const SpeedDialButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      overlayColor: Colors.grey,
      overlayOpacity: 0.4,
      icon: Icons.add,
      activeIcon: Icons.close,
      spacing: 3,
      elevation: 8.0,
      animationCurve: Curves.elasticInOut,
      animationDuration: const Duration(milliseconds: 800),
      isOpenOnStart: false,
      children: <SpeedDialChild>[
        SpeedDialChild(
          child: null,
          labelBackgroundColor: Colors.indigoAccent,
          labelStyle: const TextStyle(color: Colors.white),
          label: 'Add friend',
          onTap: () => debugPrint('Add friend tapped'),
        ),
        SpeedDialChild(
          child: null,
          labelBackgroundColor: Colors.orangeAccent,
          labelStyle: const TextStyle(color: Colors.white),
          label: 'Add group',
          onTap: () => debugPrint('Add group tapped'),
        ),
        SpeedDialChild(
          child: null,
          labelBackgroundColor: Colors.pinkAccent,
          labelStyle: const TextStyle(color: Colors.white),
          label: 'Add restaurant',
          onTap: () => Navigator.pushNamed(context, '/add-restaurant'),
        ),
      ],
    );
  }
}
