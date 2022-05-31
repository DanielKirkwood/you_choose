import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchText = '';

  CollectionReference restaurantCollection =
      FirebaseFirestore.instance.collection('/restaurants');
  List<DocumentSnapshot> documents = [];

  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    final String name = document['name'];
    final int price = document['price'];
    final List<String> tags = List<String>.from(document['tags']);
    final String description = document['description'];

    return Container(
        height: 200,
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        child: Container(
          padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Color(0xFF332d2b),
                    fontWeight: FontWeight.w700,
                    fontSize: 20),
              ),
              const SizedBox(height: 2),
              Wrap(
                children: List.generate(
                    price,
                    (index) => const Icon(
                          Icons.currency_pound,
                          color: Colors.blueAccent,
                          size: 15,
                        )),
              ),
              const SizedBox(height: 10),
              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
              ),
              const SizedBox(height: 10),
              Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: List.generate(tags.length, (index) {
                    return Chip(
                      label: Text(tags[index]),
                      backgroundColor: Colors.lightBlueAccent,
                      elevation: 2.0,
                      labelStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    );
                  }))
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 10.0, bottom: 20.0, left: 25.0, right: 25.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                  hintText: "Search...",
                  prefixIcon: Icon(Icons.search),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(color: Colors.grey, width: 0.0)),
                  border: OutlineInputBorder()),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: restaurantCollection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blueAccent,
                    ),
                  );
                }
                documents = snapshot.data!.docs;

                if (searchText.isNotEmpty) {
                  documents = documents.where((element) {
                    return element['name']
                        .toString()
                        .toLowerCase()
                        .contains(searchText.toLowerCase());
                  }).toList();
                }
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    return _buildListItem(context, documents[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-restaurant');
        },
        child: const Icon(Icons.add),
      ),
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
