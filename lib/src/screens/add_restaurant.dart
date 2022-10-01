import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:you_choose/src/bloc/group/group_bloc.dart';
import 'package:you_choose/src/bloc/restaurant/restaurant_bloc.dart';
import 'package:you_choose/src/models/models.dart';
import 'package:you_choose/src/util/constants/constants.dart';

class AddRestaurantScreen extends StatefulWidget {
  const AddRestaurantScreen({Key? key}) : super(key: key);

  @override
  State<AddRestaurantScreen> createState() => _AddRestaurantScreenState();
}

class _AddRestaurantScreenState extends State<AddRestaurantScreen> {
  String _name = '';
  int _selectedPrice = 0;
  String _description = '';
  List<Tag> _tags = [];
  List<Group> _groups = [];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add restaurant"),
      ),
      body: BlocBuilder<RestaurantBloc, RestaurantState>(
        builder: (context, state) {
          return Center(
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: size.height * 0.03),
                        DropdownButtonFormField<int>(
                          value: _selectedPrice,
                          onChanged: (int? newValue) {
                            // do other stuff with _category
                            setState(() => _selectedPrice = newValue!);
                          },
                          items: Constants.pricesInputs
                              .map<DropdownMenuItem<int>>((String value) {
                            return DropdownMenuItem<int>(
                              value: value.length - 1,
                              child: Text(value),
                            );
                          }).toList(),
                          decoration: Constants.formInputDecoration(
                              helperText:
                                  '''How expensive is the restaurant?''',
                              labelText: 'Price',
                              errorText: null),
                        ),
                        SizedBox(height: size.height * 0.03),
                        SizedBox(
                          width: size.width * 0.8,
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 5,
                            decoration: Constants.formInputDecoration(
                                helperText:
                                    '''How would you describe the restaurant?''',
                                labelText: 'Description',
                                errorText: null),
                            onChanged: (String value) {
                              setState(() {
                                _description = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: size.height * 0.03),
                        MultiSelectDialogField<String>(
                            items: Constants.tags
                                .map((e) => MultiSelectItem<String>(e, e))
                                .toList(),
                            onConfirm: (values) {
                              List<Tag> tList = [];

                              for (String element in values) {
                                tList.add(Tag(name: element));
                              }

                              _tags = tList;
                            },
                            title: const Text('Tags'),
                            searchable: true,
                            buttonText: const Text('Tags'),
                            decoration: Constants.formMultiSelect),
                        SizedBox(height: size.height * 0.03),
                        BlocBuilder<GroupBloc, GroupState>(
                          builder: (context, state) {
                            if (state is! GroupLoaded) {
                              context.read<GroupBloc>().add(const LoadGroups());
                              return const CircularProgressIndicator();
                            }
                            return MultiSelectDialogField<Group>(
                                items: state.groups
                                    .map((e) =>
                                        MultiSelectItem<Group>(e, e.name!))
                                    .toList(),
                                onConfirm: (values) {
                                  _groups = values;
                                },
                                title: const Text('Groups'),
                                searchable: true,
                                buttonText: const Text('Groups'),
                                decoration: Constants.formMultiSelect);
                          },
                        ),
                        SizedBox(height: size.height * 0.03),
                        SizedBox(
                          width: size.width * 0.8,
                          child: OutlinedButton(
                            onPressed: () {
                              Restaurant newRestaurant = Restaurant(
                                  name: _name,
                                  price: _selectedPrice,
                                  description: _description,
                                  tags: _tags);

                              print(newRestaurant);

                              BlocProvider.of<RestaurantBloc>(context).add(
                                  AddRestaurant(
                                      restaurant: newRestaurant,
                                      groups: _groups));
                            },
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Constants.kPrimaryColor),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Constants.kBlackColor),
                                side: MaterialStateProperty.all<BorderSide>(
                                    BorderSide.none)),
                            child: const Text(Constants.textAddRestaurantBtn),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
