import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:you_choose/src/bloc/authentication/authentication_bloc.dart';
import 'package:you_choose/src/screens/add_group_screen.dart';
import 'package:you_choose/src/screens/add_restaurant.dart';
import 'package:you_choose/src/screens/authentication/welcome_screen.dart';
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
        '/': (context) => const BlocNavigate(),
        '/add-restaurant': (context) => const AddRestaurantScreen(),
        '/add-group': (context) => const CreateGroupScreen(),
      },
    );
  }
}

class BlocNavigate extends StatelessWidget {
  const BlocNavigate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is AuthenticationSuccess) {
          return const HomeScreen();
        } else {
          return const WelcomeScreen();
        }
      },
    );
  }
}
