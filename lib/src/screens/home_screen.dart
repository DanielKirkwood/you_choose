import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:you_choose/src/models/restaurant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _searchController;
  String _sortValue = 'name';
  String _ascValue = "ASC";

  CollectionReference restaurantCollection = FirebaseFirestore.instance
      .collection('/restaurants')
      .withConverter<Restaurant>(
        fromFirestore: (snapshot, _) => Restaurant.fromFirestore(snapshot, _),
        toFirestore: (Restaurant restaurant, _) => restaurant.toFirestore(),
      );

  late Future resultsLoaded;
  List<Restaurant> _allResults = [];
  List<Restaurant> _resultsList = [];

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getRestaurantsStreamSnapshots();
  }

  void _onSearchChanged() {
    searchResultsList();
  }

  Future<void> searchResultsList() async {
    List<Restaurant> showResults = [];

    if (_searchController.text.isNotEmpty) {
      for (Restaurant restaurant in _allResults) {
        String name = restaurant.name.toString().toLowerCase();

        if (name.contains(_searchController.text.toLowerCase())) {
          showResults.add(restaurant);
        }
      }
    } else {
      showResults = _allResults;
    }

    setState(() => _resultsList = showResults);
  }

  Future<void> getRestaurantsStreamSnapshots() async {
    List<Restaurant> localData = [];
    List<Restaurant> serverData = [];

    const cache = Source.cache;
    const server = Source.server;

    // check local cache first
    QuerySnapshot localQuery = await restaurantCollection
        .orderBy('lastModified', descending: true)
        .get(const GetOptions(source: cache));

    if (localQuery.docs.isEmpty) {
      // no data in local cache, get all documents from server
      QuerySnapshot serverQuery = await restaurantCollection
          .orderBy('lastModified', descending: true)
          .get(const GetOptions(source: server));

      for (var element in serverQuery.docs) {
        Restaurant r = element.data() as Restaurant;
        serverData.add(r);
      }

      setState(() => _allResults = serverData);
    } else {
      // data in local cache, get documents on server which were modified after
      // the last modified document in the local cache

      for (var element in localQuery.docs) {
        Restaurant r = element.data() as Restaurant;
        localData.add(r);
      }

      Restaurant mostRecent = localData[0];
      Timestamp lastModifiedCache = mostRecent.lastModified as Timestamp;

      QuerySnapshot serverQuery = await restaurantCollection
          .orderBy('lastModified', descending: true)
          .where('lastModified', isGreaterThan: lastModifiedCache)
          .get(const GetOptions(source: server));

      for (var element in serverQuery.docs) {
        Restaurant r = element.data() as Restaurant;
        serverData.add(r);
      }

      List<Restaurant> combinedList = List.from(serverData)..addAll(localData);
      setState(() => _allResults = combinedList);
    }

    searchResultsList();
  }

  Future<void> _onPullRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    await getRestaurantsStreamSnapshots();
  }

  Widget _buildListItem(BuildContext context, Restaurant document) {
    final String? name = document.name;
    final int? price = document.price;
    final List<String>? tags = document.tags;
    final String? description = document.description;

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
                name!,
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
                    price!,
                    (index) => const Icon(
                          Icons.currency_pound,
                          color: Colors.blueAccent,
                          size: 15,
                        )),
              ),
              const SizedBox(height: 10),
              Text(
                description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
              ),
              const SizedBox(height: 10),
              Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: List.generate(tags!.length, (index) {
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

  Future<void> showFilterDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext build) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: const Center(
                  child: Text(
                "Filter",
                style: TextStyle(color: Color(0xff1B3954)),
              )),
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(top: 12, right: 10),
                      child: Row(
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.only(right: 16.0),
                            child: Icon(
                              Icons.sort,
                              color: Color(0xff808080),
                            ),
                          ),
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: const Text("Sort by"),
                                items: <String>[
                                  "name",
                                  "price",
                                  "description",
                                ].map((String value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value,
                                        style: const TextStyle(
                                            color: Color(0xff727272),
                                            fontSize: 16)),
                                  );
                                }).toList(),
                                value: _sortValue,
                                onChanged: (newValue) {
                                  setState(() {
                                    _sortValue = newValue!;
                                    _allResults.sort(
                                        (Restaurant a, Restaurant b) =>
                                            a.name!.compareTo(b.name!));
                                  });
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 8, right: 10),
                      child: Row(
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.only(right: 16.0),
                            child: Icon(
                              Icons.sort_by_alpha,
                              color: Color(0xff808080),
                            ),
                          ),
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                items: <String>[
                                  "ASC",
                                  "DESC",
                                ].map((String value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value,
                                        style: const TextStyle(
                                            color: Color(0xff727272),
                                            fontSize: 16)),
                                  );
                                }).toList(),
                                value: _ascValue,
                                onChanged: (newValue) {
                                  setState(() {
                                    _ascValue = newValue!;
                                  });
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
              forceElevated: true,
              elevation: 4,
              floating: true,
              snap: true,
              title: const Text('Home'),
              actions: <Widget>[
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.account_circle_rounded),
                  color: Colors.white,
                ),
              ],
              bottom: AppBar(
                  title: Container(
                width: double.infinity,
                alignment: Alignment.center,
                height: 40,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                          onChanged: (value) {
                            _onSearchChanged();
                          },
                          autocorrect: true,
                          controller: _searchController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            hintText: 'Search...',
                            hintStyle: TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7.0)),
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7.0)),
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 2),
                            ),
                          )),
                    ),
                    IconButton(
                      onPressed: () {
                        showFilterDialog(context);
                      },
                      icon: const Icon(Icons.filter_list),
                      color: Colors.white,
                    )
                  ],
                ),
              ))),
          CupertinoSliverRefreshControl(
            onRefresh: _onPullRefresh,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) =>
                    _buildListItem(context, _resultsList[index]),
                childCount: _resultsList.length),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-restaurant');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
