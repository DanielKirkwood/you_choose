import 'package:flutter/material.dart';

void createSnackBar(
    {required String message,
    required bool error,
    required BuildContext context}) {
  final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'Dismiss',
        onPressed: () {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
        },
        textColor: Colors.black,
      ),
      backgroundColor: error ? Colors.red : Colors.green);

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
