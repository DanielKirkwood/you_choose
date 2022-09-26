// ignore_for_file: unnecessary_new, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:you_choose/src/util/constants/constants.dart';

class AddRestaurantScreen extends StatelessWidget {
  AddRestaurantScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add restaurant"),
      ),
      body: _addRestaurantForm(context),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _addRestaurantForm(BuildContext context) {
    return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              NameField(),
              PriceField(),

            ],
          ),
        ));
  }
}

class NameField extends StatefulWidget {
  const NameField({super.key});

  @override
  State<NameField> createState() => _NameFieldState();
}

class _NameFieldState extends State<NameField> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width * 0.8,
      child: TextFormField(
        decoration: const InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          border: Constants.formInputBorder,
          helperText: '''Name must be valid''',
          helperMaxLines: 2,
          labelText: 'Name',
          errorMaxLines: 2,
          errorText: null,
        ),
        onChanged: (value) {
          return;
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
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
          filled: true,
          fillColor: Colors.grey[200],
          hintText: '£ least expensive - ££££ most expensive',
          errorText: null),
    );
  }
}
