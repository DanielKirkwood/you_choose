import 'package:flutter/material.dart';

class AddPage extends StatelessWidget {
  const AddPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: AddPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container());
  }
}
