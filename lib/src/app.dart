import 'package:flutter/material.dart';
import 'package:you_choose/src/screens/add_restaurant.dart';
import 'package:you_choose/src/screens/login_screen.dart';
import 'package:you_choose/src/screens/register_screen.dart';
import 'package:you_choose/src/services/auth.dart';

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
        '/': (context) => AuthService().handleAuthState(),
        '/add-restaurant': (context) => const AddRestaurantScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
      },
    );
  }
}
