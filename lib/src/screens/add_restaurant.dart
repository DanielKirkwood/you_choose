import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:you_choose/src/bloc/group/group_bloc.dart';
import 'package:you_choose/src/util/constants/constants.dart';

class AddRestaurantScreen extends StatelessWidget {
  AddRestaurantScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add restaurant"),
      ),
      body: Center(
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
              Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const NameField(),
                        SizedBox(height: size.height * 0.03),
                        const PriceField(),
                        SizedBox(height: size.height * 0.03),
                        const DescriptionField(),
                        SizedBox(height: size.height * 0.03),
                        const TagsField(),
                        SizedBox(height: size.height * 0.03),
                        const GroupsField(),
                        SizedBox(height: size.height * 0.03),
                        const _SubmitButton(),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class NameField extends StatefulWidget {
  const NameField({super.key});

  @override
  State<NameField> createState() => _NameFieldState();
}

class _NameFieldState extends State<NameField> {
  // TODO: add error reporting via bloc
  String _name = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width * 0.8,
      child: TextFormField(
        keyboardType: TextInputType.name,
        maxLines: 1,
        decoration: Constants.formInputDecoration(
            helperText: '''What's the restaurants name?''',
            labelText: 'Name',
            errorText: null),
        onChanged: (String value) {
          setState(() {
            _name = value;
          });
        },
      ),
    );
  }
}

class PriceField extends StatefulWidget {
  const PriceField({super.key});

  @override
  State<PriceField> createState() => _PriceFieldState();
}

class _PriceFieldState extends State<PriceField> {
  int _selectedPrice = 0;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      value: _selectedPrice,
      onChanged: (int? newValue) {
        // do other stuff with _category
        setState(() => _selectedPrice = newValue!);
      },
      items: Constants.pricesInputs.map<DropdownMenuItem<int>>((String value) {
        return DropdownMenuItem<int>(
          value: value.length - 1,
          child: Text(value),
        );
      }).toList(),
      decoration: Constants.formInputDecoration(
          helperText: '''How expensive is the restaurant?''',
          labelText: 'Price',
          errorText: null),
    );
  }
}

class DescriptionField extends StatefulWidget {
  const DescriptionField({super.key});

  @override
  State<DescriptionField> createState() => _DescriptionFieldState();
}

class _DescriptionFieldState extends State<DescriptionField> {
  String _description = '';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width * 0.8,
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: 5,
        decoration: Constants.formInputDecoration(
            helperText: '''How would you describe the restaurant?''',
            labelText: 'Description',
            errorText: null),
        onChanged: (String value) {
          setState(() {
            _description = value;
          });
        },
      ),
    );
  }
}

class TagsField extends StatefulWidget {
  const TagsField({super.key});

  @override
  State<TagsField> createState() => _TagsFieldState();
}

class _TagsFieldState extends State<TagsField> {
  List<String> _tags = [];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width * 0.8,
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: 5,
        decoration: Constants.formInputDecoration(
            helperText: '''How would you categorise the restaurant?''',
            labelText: 'Tags',
            errorText: null),
        onChanged: (String value) {
          List<String> tagList = [];
          List<String> split = value.split(',');
          for (var element in split) {
            tagList.add(element.trim());
          }
          setState(() {
            _tags = tagList;
          });
        },
      ),
    );
  }
}

class GroupsField extends StatefulWidget {
  const GroupsField({super.key});

  @override
  State<GroupsField> createState() => _GroupsFieldState();
}

class _GroupsFieldState extends State<GroupsField> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupBloc, GroupState>(
      builder: (context, state) {
        if (state is! GroupLoaded) {
          context.read<GroupBloc>().add(const LoadGroups());
          return const CircularProgressIndicator();
        }
        return Container();
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width * 0.8,
      child: OutlinedButton(
        onPressed: null,
        style: ButtonStyle(
            foregroundColor:
                MaterialStateProperty.all<Color>(Constants.kPrimaryColor),
            backgroundColor:
                MaterialStateProperty.all<Color>(Constants.kBlackColor),
            side: MaterialStateProperty.all<BorderSide>(BorderSide.none)),
        child: const Text(Constants.textAddRestaurantBtn),
      ),
    );
  }
}
