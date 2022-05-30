import 'package:flutter/material.dart';
import 'package:you_choose/src/screens/add_restaurant.dart';
import 'package:you_choose/src/screens/home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'You Choose',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Poppins'),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/add-restaurant': (context) => const AddRestaurantScreen()
      },
    );
  }
}
