import 'package:flutter/widgets.dart';
import 'package:you_choose/src/app/app.dart';
import 'package:you_choose/src/home/home.dart';
import 'package:you_choose/src/welcome/welcome.dart';

List<Page<dynamic>> onGenerateAppViewPages(
  AppStatus state,
  List<Page<dynamic>> pages,
) {
  switch (state) {
    case AppStatus.authenticated:
      return [HomePage.page()];
    case AppStatus.unauthenticated:
      return [WelcomePage.page()];
  }
}
