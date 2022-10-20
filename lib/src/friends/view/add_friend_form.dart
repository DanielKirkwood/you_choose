import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:you_choose/src/app/app.dart';
import 'package:you_choose/src/data/data.dart';
import 'package:you_choose/src/friends/cubit/friends_cubit.dart';
import 'package:you_choose/src/util/constants/constants.dart';

class AddFriendForm extends StatelessWidget {
  const AddFriendForm({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<FriendsCubit, FriendsState>(
      listener: (context, state) {
        if (state.formStatus.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Could not add friend'),
              ),
            );
        }
        if (state.formStatus.isSubmissionSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text('${state.username.value} successfully added.'),
              ),
            );
        }
      },
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: Constants.textAddFriendTitle,
                        style: TextStyle(
                          color: Constants.kBlackColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                        )),
                  ])),
              Padding(padding: EdgeInsets.only(bottom: size.height * 0.02)),
              const _UsernameField(),
              SizedBox(height: size.height * 0.01),
              const _AddFriendButton()
            ],
          ),
        ),
      ),
    );
  }
}

class _UsernameField extends StatelessWidget {
  const _UsernameField({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocBuilder<FriendsCubit, FriendsState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return SizedBox(
          width: size.width * 0.8,
          child: TextField(
              key: const Key('friendForm_usernameInput_textField'),
              onChanged: (username) =>
                  context.read<FriendsCubit>().usernameChanged(username),
              decoration: InputDecoration(
                labelText: 'Username',
                errorText: state.username.invalid ? 'invalid username' : null,
                hintText: 'Username',
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 10.0),
                border: Constants.formInputBorder,
              )),
        );
      },
    );
  }
}

class _AddFriendButton extends StatelessWidget {
  const _AddFriendButton({super.key});

  @override
  Widget build(BuildContext context) {
    UserModel user = context.select((AppBloc bloc) => bloc.state.user);
    Size size = MediaQuery.of(context).size;

    return BlocBuilder<FriendsCubit, FriendsState>(
      buildWhen: (previous, current) =>
          previous.formStatus != current.formStatus,
      builder: (context, state) {
        return state.formStatus.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : SizedBox(
                width: size.width * 0.8,
                child: OutlinedButton(
                  key: const Key('friendForm_continue_raisedButton'),
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Constants.kPrimaryColor),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Constants.kBlackColor),
                      side: MaterialStateProperty.all<BorderSide>(
                          BorderSide.none)),
                  onPressed: state.formStatus.isValidated
                      ? () => context
                          .read<FriendsCubit>()
                          .sendFriendRequest(userID: user.uid)
                      : null,
                  child: const Text(Constants.textAddFriendBtn),
                ),
              );
      },
    );
  }
}
