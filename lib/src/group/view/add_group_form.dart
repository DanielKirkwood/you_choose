import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:you_choose/src/app/app.dart';
import 'package:you_choose/src/data/data.dart';
import 'package:you_choose/src/group/cubit/group_cubit.dart';
import 'package:you_choose/src/util/constants/constants.dart';

class AddGroupForm extends StatelessWidget {
  const AddGroupForm({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<GroupCubit, GroupState>(
      listener: (context, state) {
        if (state.formStatus.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Could not add group'),
              ),
            );
        }
        if (state.formStatus.isSubmissionSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text('${state.name.value} successfully created.'),
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
                        text: Constants.textAddGroupTitle,
                        style: TextStyle(
                          color: Constants.kBlackColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                        )),
                  ])),
              Padding(padding: EdgeInsets.only(bottom: size.height * 0.02)),
              const _NameField(),
              SizedBox(height: size.height * 0.01),
              const _MembersField(),
              SizedBox(height: size.height * 0.01),
              const _AddGroupButton()
            ],
          ),
        ),
      ),
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocBuilder<GroupCubit, GroupState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return SizedBox(
          width: size.width * 0.8,
          child: TextField(
              key: const Key('groupForm_nameInput_textField'),
              onChanged: (name) => context.read<GroupCubit>().nameChanged(name),
              decoration: InputDecoration(
                labelText: 'Name',
                errorText: state.name.invalid ? 'invalid name' : null,
                hintText: 'Name',
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 10.0),
                border: Constants.formInputBorder,
              )),
        );
      },
    );
  }
}

class _MembersField extends StatelessWidget {
  const _MembersField({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocBuilder<GroupCubit, GroupState>(
      buildWhen: (previous, current) => previous.members != current.members,
      builder: (context, state) {
        return SizedBox(
          width: size.width * 0.8,
          child: TextField(
              key: const Key('groupForm_membersInput_textField'),
              onChanged: (members) =>
                  context.read<GroupCubit>().membersChanged(members),
              decoration: InputDecoration(
                labelText: 'Members',
                errorText: state.members.invalid ? 'invalid members' : null,
                hintText: 'Members',
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 10.0),
                border: Constants.formInputBorder,
              )),
        );
      },
    );
  }
}

class _AddGroupButton extends StatelessWidget {
  const _AddGroupButton({super.key});

  @override
  Widget build(BuildContext context) {
    UserModel user = context.select((AppBloc bloc) => bloc.state.user);
    Size size = MediaQuery.of(context).size;

    return BlocBuilder<GroupCubit, GroupState>(
      buildWhen: (previous, current) =>
          previous.formStatus != current.formStatus,
      builder: (context, state) {
        return state.formStatus.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : SizedBox(
                width: size.width * 0.8,
                child: OutlinedButton(
                  key: const Key('groupForm_continue_raisedButton'),
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Constants.kPrimaryColor),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Constants.kBlackColor),
                      side: MaterialStateProperty.all<BorderSide>(
                          BorderSide.none)),
                  onPressed: state.formStatus.isValidated
                      ? () => context.read<GroupCubit>().addGroup(user.uid)
                      : null,
                  child: const Text(Constants.textAddGroupBtn),
                ),
              );
      },
    );
  }
}
