import 'package:flutter/material.dart';
import 'package:you_choose/src/models/models.dart';
import 'package:you_choose/src/util/constants/constants.dart';

class GroupDetailScreen extends StatefulWidget {
  final Group group;
  const GroupDetailScreen({super.key, required this.group});

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    Text(
                      widget.group.name!,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () =>
                          Navigator.pushNamed(context, '/add-restaurant'),
                      child: Row(
                        children: const <Widget>[
                          Icon(
                            Icons.add,
                            color: Constants.kDarkBlueColor,
                            size: 20,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            "Add Restaurant",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    const Icon(
                      Icons.settings,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Constants.kDarkBlueColor,
        unselectedItemColor: Constants.kBlackColor,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Groups',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget searchBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search...",
          hintStyle: TextStyle(color: Colors.grey.shade600),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey.shade600,
            size: 20,
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: const EdgeInsets.all(8),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.grey.shade100)),
        ),
      ),
    );
  }
}
