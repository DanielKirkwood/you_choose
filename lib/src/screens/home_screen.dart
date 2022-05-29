import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('/restaurants').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text('Loading...');
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return _buildListItem(context, snapshot.data!.docs[index]);
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const FloatingActionButton(
        onPressed: null,
        child: Icon(Icons.add),
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
