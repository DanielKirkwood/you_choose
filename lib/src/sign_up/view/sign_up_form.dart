import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:you_choose/src/sign_up/cubit/sign_up_cubit.dart';
import 'package:you_choose/src/util/constants/constants.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state.status.isSubmissionSuccess) {
          Navigator.of(context).pop();
        } else if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Sign Up Failure')),
            );
        }
      },
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(Constants.textRegister,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Constants.kBlackColor,
                    fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: size.height * 0.02)),
              const _EmailField(),
              const SizedBox(height: 8),
              const _PasswordField(),
              const SizedBox(height: 8),
              const _ConfirmPasswordField(),
              const SizedBox(height: 8),
              _SignUpButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return SizedBox(
          width: size.width * 0.8,
          child: TextField(
              key: const Key('signUpForm_emailInput_textField'),
              onChanged: (email) =>
                  context.read<SignUpCubit>().emailChanged(email),
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: state.email.invalid ? 'invalid email' : null,
                hintText: 'Email',
                contentPadding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 10,
              ),
                border: Constants.formInputBorder,
            ),
          ),
        );
      },
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return SizedBox(
          width: size.width * 0.8,
          child: TextField(
              key: const Key('signUpForm_passwordInput_textField'),
              onChanged: (password) =>
                  context.read<SignUpCubit>().passwordChanged(password),
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: state.password.invalid ? 'invalid password' : null,
                hintText: 'Password',
                contentPadding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 10,
              ),
                border: Constants.formInputBorder,
            ),
          ),
        );
      },
    );
  }
}

class _ConfirmPasswordField extends StatelessWidget {
  const _ConfirmPasswordField();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.confirmedPassword != current.confirmedPassword,
      builder: (context, state) {
        return SizedBox(
          width: size.width * 0.8,
          child: TextField(
              key: const Key('signUpForm_passwordInput_textField'),
              onChanged: (confirmedPassword) => context
                  .read<SignUpCubit>()
                  .confirmedPasswordChanged(confirmedPassword),
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                errorText: state.confirmedPassword.invalid
                    ? 'passwords do not match'
                    : null,
                hintText: 'Confirm Password',
                contentPadding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 10,
              ),
                border: Constants.formInputBorder,
            ),
          ),
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<SignUpCubit, SignUpState>(
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
                      Constants.kPrimaryColor,
                    ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                      Constants.kBlackColor,
                    ),
                      side: MaterialStateProperty.all<BorderSide>(
                      BorderSide.none,
                    ),
                  ),
                  onPressed: state.status.isValidated
                      ? () => context.read<SignUpCubit>().signUpFormSubmitted()
                      : null,
                  child: const Text(Constants.textSignUp),
                ),
              );
      },
    );
  }
}
