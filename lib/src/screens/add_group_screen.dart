import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:you_choose/src/util/constants/constants.dart';

OutlineInputBorder border = const OutlineInputBorder(
    borderSide: BorderSide(color: Constants.kBorderColor, width: 3.0));

class AddGroupScreen extends StatelessWidget {
  const AddGroupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return MultiBlocListener(
      listeners: [
        BlocListener<FormBloc, FormsValidate>(
          listener: (context, state) {
            if (state.errorMessage.isNotEmpty) {
              showDialog(
                  context: context,
                  builder: (context) =>
                      ErrorDialog(errorMessage: state.errorMessage));
            } else if (state.isFormValidateFailed) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(Constants.textFixIssues)));
            }
          },
        ),
        BlocListener<GroupBloc, GroupState>(
          listener: (context, state) {
            if (state is GroupAdded) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(Constants.textGroupAdded)));

              Navigator.pushNamed(context, '/');

            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle:
              const SystemUiOverlayStyle(
            statusBarColor: Colors.blue,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
          ),
          title: const Text(Constants.textAddGroupTitle),
        ),
        backgroundColor: Constants.kPrimaryColor,
        body: Center(
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
              const _GroupNameField(),
              SizedBox(height: size.height * 0.01),
              const _GroupMembersField(),
              SizedBox(height: size.height * 0.01),
              const _SubmitButton(),
            ],
          ),
        )),
      ),
    );
  }
}

class _GroupNameField extends StatelessWidget {
  const _GroupNameField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<FormBloc, FormsValidate>(
      builder: (context, state) {
        return SizedBox(
          width: size.width * 0.8,
          child: TextFormField(
              onChanged: (value) {

                context.read<FormBloc>().add(GroupNameChanged(value));
              },
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Name',
                helperText: 'Names can be mix of letters and numbers',
                errorText: !state.isGroupNameValid
                    ? 'Please ensure the name entered is valid'
                    : null,
                hintText: 'Name',
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 10.0),
                border: border,
              )),
        );
      },
    );
  }
}

class _GroupMembersField extends StatelessWidget {
  const _GroupMembersField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<FormBloc, FormsValidate>(
      builder: (context, state) {
        return SizedBox(
          width: size.width * 0.8,
          child: TextFormField(
              onChanged: (value) {
                List<String> membersList = [];
                List<String> split = value.split(',');
                for (var element in split) {
                  membersList.add(element.trim());
                }
                context.read<FormBloc>().add(GroupMembersChanged(membersList));
              },
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Group Members',
                helperText: 'Usernames as comma-separated list',
                errorText: !state.isGroupMembersValid
                    ? 'Please ensure the list of members is valid'
                    : null,
                hintText: 'Group Members',
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 10.0),
                border: border,
              )),
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<FormBloc, FormsValidate>(
      builder: (context, state) {
        return state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SizedBox(
                width: size.width * 0.8,
                child: OutlinedButton(
                  onPressed: !state.isFormValid
                      ? () {

                          BlocProvider.of<GroupBloc>(context).add(AddGroup(
                              name: state.groupName,
                              groupMembers: state.groupMembers));
                          context.read<FormBloc>().add(const FormReset());
                        }
                      : null,
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Constants.kPrimaryColor),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Constants.kBlackColor),
                      side: MaterialStateProperty.all<BorderSide>(
                          BorderSide.none)),
                  child: const Text(Constants.textAddGroupBtn),
                ),
              );
      },
    );
  }
}

class ErrorDialog extends StatelessWidget {
  final String? errorMessage;
  const ErrorDialog({Key? key, required this.errorMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Error"),
      content: Text(errorMessage!),
      actions: [
        TextButton(
          child: const Text("Ok"),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  }
}
