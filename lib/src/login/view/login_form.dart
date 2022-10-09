import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:you_choose/src/login/cubit/login_cubit.dart';
import 'package:you_choose/src/sign_up/sign_up.dart';
import 'package:you_choose/src/util/constants/constants.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.status.isSubmissionFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Authentication Failure'),
                ),
              );
          }
        },
        child: Center(
            child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(children: <TextSpan>[
                  TextSpan(
                      text: Constants.textSignInTitle,
                      style: TextStyle(
                        color: Constants.kBlackColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                      )),
                ])),
            SizedBox(height: size.height * 0.01),
            const Text(
              Constants.textSmallSignIn,
              style: TextStyle(color: Constants.kDarkGreyColor),
            ),
            Padding(padding: EdgeInsets.only(bottom: size.height * 0.02)),
            const _EmailField(),
            SizedBox(height: size.height * 0.01),
            const _PasswordField(),
            SizedBox(height: size.height * 0.01),
            _LoginButton(),
            const _SignInNavigate(),
          ]),
        )));
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return SizedBox(
          width: size.width * 0.8,
          child: TextField(
              key: const Key('loginForm_emailInput_textField'),
              onChanged: (email) =>
                  context.read<LoginCubit>().emailChanged(email),
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: state.email.invalid ? 'invalid email' : null,
                hintText: 'Email',
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 10.0),
                border: Constants.formInputBorder,
              )),
        );
      },
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return SizedBox(
          width: size.width * 0.8,
          child: TextField(
              key: const Key('loginForm_passwordInput_textField'),
              onChanged: (password) =>
                  context.read<LoginCubit>().passwordChanged(password),
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: state.password.invalid ? 'invalid password' : null,
                hintText: 'Password',
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 10.0),
                border: Constants.formInputBorder,
              )),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : SizedBox(
                width: size.width * 0.8,
                child: OutlinedButton(
                  key: const Key('loginForm_continue_raisedButton'),
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Constants.kPrimaryColor),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Constants.kBlackColor),
                      side: MaterialStateProperty.all<BorderSide>(
                          BorderSide.none)),
                  onPressed: state.status.isValidated
                      ? () => context.read<LoginCubit>().logInWithCredentials()
                      : null,
                  child: const Text(Constants.textSignIn),
                ),
              );
      },
    );
  }
}

class _SignInNavigate extends StatelessWidget {
  const _SignInNavigate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: <TextSpan>[
          const TextSpan(
              text: Constants.textAcc,
              style: TextStyle(
                color: Constants.kDarkGreyColor,
              )),
          TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () => {
                      Navigator.of(context).pop(),
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpPage()),
                      )
                    },
              text: Constants.textSignUp,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Constants.kDarkBlueColor,
              )),
        ]));
  }
}
