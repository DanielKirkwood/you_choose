import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:you_choose/src/app/app.dart';
import 'package:you_choose/src/data/data.dart';
import 'package:you_choose/src/group/cubit/group_cubit.dart';
import 'package:you_choose/src/restaurant/cubit/restaurant_cubit.dart';
import 'package:you_choose/src/tag/cubit/tag_cubit.dart';
import 'package:you_choose/src/util/constants/constants.dart';

class AddRestaurantForm extends StatelessWidget {
  const AddRestaurantForm({super.key, required this.groupID});

  final String groupID;


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocListener<RestaurantCubit, RestaurantState>(
      listener: (context, state) {
        if (state.formStatus.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Could not add restaurant'),
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
                        text: Constants.textAddRestaurantTitle,
                        style: TextStyle(
                          color: Constants.kBlackColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                        )),
                  ])),
              Padding(padding: EdgeInsets.only(bottom: size.height * 0.02)),
              const _NameField(),
              SizedBox(height: size.height * 0.03),
              const _PriceField(),
              SizedBox(height: size.height * 0.03),
              const _DescriptionField(),
              SizedBox(height: size.height * 0.03),
              const _TagsField(),
              SizedBox(height: size.height * 0.03),
              const _GroupsField(),
              SizedBox(height: size.height * 0.03),
              const _AddRestaurantButton(),
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

    return BlocBuilder<RestaurantCubit, RestaurantState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return SizedBox(
          width: size.width * 0.8,
          child: TextField(
              key: const Key('restaurantForm_nameInput_textField'),
              onChanged: (name) =>
                  context.read<RestaurantCubit>().nameChanged(name),
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

class _PriceField extends StatelessWidget {
  const _PriceField({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocBuilder<RestaurantCubit, RestaurantState>(
      buildWhen: (previous, current) => previous.price != current.price,
      builder: (context, state) {
        return SizedBox(
          width: size.width * 0.8,
          child: DropdownButtonFormField<int>(
            value: state.price.value,
            onChanged: (int? price) =>
                context.read<RestaurantCubit>().priceChanged(price!),
            items: Constants.pricesInputs
                .map<DropdownMenuItem<int>>((String value) {
              return DropdownMenuItem<int>(
                value: value.length,
                child: Text(value),
              );
            }).toList(),
            decoration: Constants.formInputDecoration(
                helperText: null,
                labelText: 'Price',
                errorText: null),
          ),
        );
      },
    );
  }
}

class _DescriptionField extends StatelessWidget {
  const _DescriptionField({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocBuilder<RestaurantCubit, RestaurantState>(
      buildWhen: (previous, current) =>
          previous.description != current.description,
      builder: (context, state) {
        return SizedBox(
          width: size.width * 0.8,
          child: TextField(
              key: const Key('restaurantForm_descriptionInput_textField'),
              onChanged: (description) => context
                  .read<RestaurantCubit>()
                  .descriptionChanged(description),
              decoration: InputDecoration(
                labelText: 'Description',
                errorText:
                    state.description.invalid ? 'invalid description' : null,
                hintText: 'Description',
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 10.0),
                border: Constants.formInputBorder,
              )),
        );
      },
    );
  }
}

class _TagsField extends StatelessWidget {
  const _TagsField({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    UserModel user = context.select((AppBloc bloc) => bloc.state.user);

    return BlocBuilder<RestaurantCubit, RestaurantState>(
      buildWhen: (previous, current) => previous.tags != current.tags,
      builder: (context, state) {
        return SizedBox(
          width: size.width * 0.8,
          child: BlocBuilder<TagCubit, TagState>(
            builder: (context, state) {
              if (state.status == TagStatus.initial) {
                context.read<TagCubit>().loadTags();
                return const Center(child: CircularProgressIndicator());
              }
              if (state.status == TagStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.status == TagStatus.failure) {
                return const Center(
                  child: Text('There was an error loading tag data.'),
                );
              }
              if (state.status == TagStatus.success) {
                if (state.tags.isEmpty) {
                  return const Center(
                    child: Text(Constants.textNoData),
                  );
                }
                return MultiSelectDialogField<Tag>(
                    items: state.tags
                        .map((e) => MultiSelectItem<Tag>(e, e.name))
                        .toList(),
                    onConfirm: (tags) =>
                        context.read<RestaurantCubit>().tagsChanged(tags),
                    title: const Text('Tags'),
                    searchable: true,
                    buttonText: const Text('Tags'),
                    decoration: Constants.formMultiSelect);
              }
              return const Center(child: Text('An unknown error has occurred'));
            },
          ),
        );
      },
    );
  }
}

class _GroupsField extends StatelessWidget {
  const _GroupsField({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    UserModel user = context.select((AppBloc bloc) => bloc.state.user);

    return BlocBuilder<RestaurantCubit, RestaurantState>(
      buildWhen: (previous, current) => previous.groups != current.groups,
      builder: (context, state) {
        return SizedBox(
          width: size.width * 0.8,
          child: BlocBuilder<GroupCubit, GroupState>(
            builder: (context, state) {
              if (state.status == GroupStatus.initial) {
                context.read<GroupCubit>().loadGroups(user.uid);
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
                        context.read<RestaurantCubit>().groupsChanged(groups),
                    title: const Text('Groups'),
                    searchable: true,
                    buttonText: const Text('Groups'),
                    decoration: Constants.formMultiSelect);
              }
              return const Center(child: Text('An unknown error has occurred'));
            },
          ),
        );
      },
    );
  }
}

class _AddRestaurantButton extends StatelessWidget {
  const _AddRestaurantButton({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocBuilder<RestaurantCubit, RestaurantState>(
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
                      ? () => context.read<RestaurantCubit>().addRestaurant()
                      : null,
                  child: const Text(Constants.textAddGroupBtn),
                ),
              );
      },
    );
  }
}
