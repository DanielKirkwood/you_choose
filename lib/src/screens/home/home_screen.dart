import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:you_choose/src/bloc/authentication/authentication_bloc.dart';
import 'package:you_choose/src/screens/authentication/welcome_screen.dart';
import 'package:you_choose/src/screens/home/groups_screen.dart';
import 'package:you_choose/src/util/constants/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationFailure) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              (Route<dynamic> route) => false);
        }
      },
      buildWhen: ((previous, current) {
        if (current is AuthenticationFailure) {
          return false;
        }
        return true;
      }),
      builder: (context, state) {
        return Scaffold(
          body: const GroupsScreen(),
          // floatingActionButton: const SpeedDialButton(),
          bottomNavigationBar: BottomNavigationBar(
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
                icon: Icon(Icons.add),
                label: 'Add',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}
