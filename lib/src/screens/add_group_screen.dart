import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:you_choose/src/services/authentication/authentication_service.dart';

class CreateGroupForm extends StatefulWidget {
  const CreateGroupForm({Key? key}) : super(key: key);

  @override
  State<CreateGroupForm> createState() => _CreateGroupFormState();
}

class _CreateGroupFormState extends State<CreateGroupForm> {
  final _formKey = GlobalKey<FormState>();
  String _groupName = "";
  List<String> _members = [];

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final AuthenticationService _authService = AuthenticationService();

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      return;
    }

    _formKey.currentState!.reset();
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
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                  labelText: 'Group Name',
                  hintText: 'Give your group a fun name',
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(color: Colors.grey, width: 0.0)),
                  border: OutlineInputBorder()),
              onFieldSubmitted: (String value) {
                setState(() => _groupName = value);
              },
              onChanged: (String value) {
                setState(() => _groupName = value);
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please provide a name';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                  labelText: 'Group Members',
                  hintText: 'Enter usernames as comma-separated list',
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(color: Colors.grey, width: 0.0)),
                  border: OutlineInputBorder()),
              onFieldSubmitted: (String value) async {
                List<String> parts = value.split(',');
                for (var element in parts) {
                  element.trim();
                }
                parts.removeWhere((item) => [""].contains(item));

                List<String> users = [];

                for (var element in parts) {
                  users.add(element);
                }
                setState(() => _members = users);
              },
              onChanged: (String value) {
                List<String> parts = value.split(',');
                for (var element in parts) {
                  element.trim();
                }
                parts.removeWhere((item) => [""].contains(item));

                List<String> users = [];

                for (var element in parts) {
                  users.add(element);
                }
                setState(() => _members = users);
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please provide at least 1 other member';
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

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Group"),
      ),
      body: const CreateGroupForm(),
    );
  }
}
