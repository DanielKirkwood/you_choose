import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:you_choose/src/repositories/repositories.dart';
import 'package:you_choose/src/sign_up/sign_up.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const SignUpPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) =>
            SignUpCubit(context.read<FirebaseAuthRepository>()),
        child: const SignUpForm(),
      ),
    );
  }
}
