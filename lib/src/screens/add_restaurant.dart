import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:you_choose/src/models/restaurant.dart';
import 'package:you_choose/src/widgets/slider_form_field.dart';

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

      final restaurant = Restaurant(
          name: _name, price: _price, description: _description, tags: _tags);

      FirebaseFirestore db = FirebaseFirestore.instance;
      final docRef = db
          .collection('/restaurants')
          .withConverter(
              fromFirestore: Restaurant.fromFirestore,
              toFirestore: (Restaurant restaurant, options) =>
                  restaurant.toFirestore())
          .doc();

      docRef.set(restaurant).then((value) {
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.name,
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
                  return 'Please provide a name';
                }
                return null;
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'How would you describe the restaurant?',
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(color: Colors.grey, width: 0.0)),
                  border: OutlineInputBorder()),
              onFieldSubmitted: (String value) {
                setState(() => _description = value);
              },
              onChanged: (String value) {
                setState(() => _description = value);
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please provide a description';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                  labelText: 'Tags',
                  hintText:
                      'Enter tags as a comma seperated list: fancy, special occasion, steak',
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(color: Colors.grey, width: 0.0)),
                  border: OutlineInputBorder()),
              onFieldSubmitted: (String value) {
                List<String> parts = value.split(',');
                for (var element in parts) {
                  element.trim();
                }
                parts.removeWhere((item) => [""].contains(item));
                setState(() => _tags = parts);
              },
              onChanged: (String value) {
                List<String> parts = value.split(',');
                for (var element in parts) {
                  element.trim();
                }
                setState(() => _tags = parts);
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please provide at least one tag';
                }
                return null;
              },
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
