import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:you_choose/src/bloc/authentication/authentication_bloc.dart';
import 'package:you_choose/src/screens/add_group_screen.dart';
import 'package:you_choose/src/screens/add_restaurant.dart';
import 'package:you_choose/src/screens/authentication/welcome_screen.dart';
import 'package:you_choose/src/screens/home/home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'You Choose',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Poppins',
          appBarTheme: const AppBarTheme(
              systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light,
          ))),
      initialRoute: '/',
      routes: {
        '/': (context) => const BlocNavigate(screen: HomeScreen()),
        '/add-restaurant': (context) =>
            const BlocNavigate(screen: AddRestaurantScreen()),
        '/add-group': (context) => const BlocNavigate(screen: AddGroupScreen()),
      },
    );
  }
}

class BlocNavigate extends StatelessWidget {
  final Widget screen;

  const BlocNavigate({Key? key, required this.screen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is AuthenticationSuccess) {
          return screen;
        } else {
          return const WelcomeScreen();
        }
      },
    );
  }
}
