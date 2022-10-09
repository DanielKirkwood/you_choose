import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:you_choose/src/login/login.dart';
import 'package:you_choose/src/repositories/repositories.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: LoginPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
      create: (_) => LoginCubit(context.read<FirebaseAuthRepository>()),
      child: const LoginForm(),
    ));
  }
}
