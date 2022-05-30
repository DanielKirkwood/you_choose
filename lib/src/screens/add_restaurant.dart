import 'package:flutter/material.dart';
import 'package:you_choose/src/widgets/SliderFormField.dart';

class AddRestaurantForm extends StatefulWidget {
  const AddRestaurantForm({Key? key}) : super(key: key);

  @override
  State<AddRestaurantForm> createState() => _AddRestaurantFormState();
}

class _AddRestaurantFormState extends State<AddRestaurantForm> {
  final _formKey = GlobalKey<FormState>();

  String _name = "";
  int _price = 1;
  String _description = "";
  List<String> _tags = [];

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'What is the name of the restaurant',
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(color: Colors.grey, width: 0.0)),
                  border: OutlineInputBorder()),
              onFieldSubmitted: (String value) {
                setState(() => _name = value);
              },
              onChanged: (String value) {
                setState(() => _name = value);
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            Row(
              children: [
                const Text('Price:'),
                SliderFormField(onSaved: (value) {
                  setState(() => _price = value!.round().toInt());
                }, validator: (value) {
                  if (value! <= 0.0) {
                    return 'not allowed';
                  }
                  return null;
                }),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(60)),
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  _submit();
                }
              },
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}

class AddRestaurantScreen extends StatefulWidget {
  const AddRestaurantScreen({Key? key}) : super(key: key);

  @override
  State<AddRestaurantScreen> createState() => _AddRestaurantScreenState();
}

class _AddRestaurantScreenState extends State<AddRestaurantScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add restaurant"),
      ),
      body: const AddRestaurantForm(),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            IconButton(onPressed: null, icon: Icon(Icons.home)),
            IconButton(
                onPressed: null, icon: Icon(Icons.account_circle_rounded)),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
