import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:models/models.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:you_choose/src/app/app.dart';
import 'package:you_choose/src/group/cubit/group_cubit.dart';
import 'package:you_choose/src/tag/cubit/tag_cubit.dart';
import 'package:you_choose/src/util/constants/constants.dart';

class AddTagForm extends StatelessWidget {
  const AddTagForm({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocListener<TagCubit, TagState>(
      listener: (context, state) {
        if (state.formStatus.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Could not add tag'),
              ),
            );
        }
        if (state.formStatus.isSubmissionSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text('${state.name.value} tag successfully created.'),
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
                        text: Constants.textAddTagTitle,
                        style: TextStyle(
                          color: Constants.kBlackColor,
                          fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: size.height * 0.02)),
              const _NameField(),
              SizedBox(height: size.height * 0.03),
              const _GroupsField(),
              SizedBox(height: size.height * 0.03),
              const _AddTagButton()
            ],
          ),
        ),
      ),
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<TagCubit, TagState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return SizedBox(
          width: size.width * 0.8,
          child: TextField(
              key: const Key('tagForm_nameInput_textField'),
              onChanged: (name) => context.read<TagCubit>().nameChanged(name),
              decoration: InputDecoration(
                labelText: 'Name',
                errorText: state.name.invalid ? 'invalid name' : null,
                hintText: 'Name',
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

class _GroupsField extends StatelessWidget {
  const _GroupsField();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = context.select((AppBloc bloc) => bloc.state.user);

    return BlocBuilder<TagCubit, TagState>(
      buildWhen: (previous, current) => previous.groups != current.groups,
      builder: (context, state) {
        return SizedBox(
          width: size.width * 0.8,
          child: BlocBuilder<GroupCubit, GroupState>(
            builder: (context, state) {
              if (state.status == GroupStatus.initial) {
                context.read<GroupCubit>().loadGroups(username: user.username);
                return const Center(child: CircularProgressIndicator());
              }
              if (state.status == GroupStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.status == GroupStatus.failure) {
                return const Center(
                  child: Text('There was an error loading group data.'),
                );
              }
              if (state.status == GroupStatus.success) {
                if (state.groups.isEmpty) {
                  return const Center(
                    child: Text(Constants.textNoData),
                  );
                }
                return MultiSelectDialogField<Group>(
                    items: state.groups
                        .map((e) => MultiSelectItem<Group>(e, e.name))
                        .toList(),
                    onConfirm: (groups) =>
                        context.read<TagCubit>().groupsChanged(groups),
                    title: const Text('Groups'),
                    searchable: true,
                    buttonText: const Text('Groups'),
                  decoration: Constants.formMultiSelect,
                );
              }
              return const Center(child: Text('An unknown error has occurred'));
            },
          ),
        );
      },
    );
  }
}

class _AddTagButton extends StatelessWidget {
  const _AddTagButton();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<TagCubit, TagState>(
      buildWhen: (previous, current) =>
          previous.formStatus != current.formStatus,
      builder: (context, state) {
        return state.formStatus.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : SizedBox(
                width: size.width * 0.8,
                child: OutlinedButton(
                  key: const Key('tagForm_continue_raisedButton'),
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
                  onPressed: state.formStatus.isValidated
                      ? () {
                          for (final group in state.groups.value) {
                            context
                                .read<TagCubit>()
                                .addTag(groupID: group.docID!);
                          }
                        }
                      : null,
                  child: const Text(Constants.textAddTagBtn),
                ),
              );
      },
    );
  }
}
