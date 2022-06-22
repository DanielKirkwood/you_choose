import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:you_choose/src/models/restaurant.dart';
import 'package:you_choose/src/services/auth.dart';
import 'package:you_choose/src/widgets/restaurant_list.dart';
import 'package:you_choose/src/widgets/search_filter_restaurants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getRestaurantsStreamSnapshots();
  }

  void updateResults(List<Restaurant> newList) {
    setState(() {
      _resultsList = newList;
    });
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

      updateResults(serverData);
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
      updateResults(combinedList);
      setState(() => _allResults = combinedList);
    }
  }

  Future<void> _onPullRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    await getRestaurantsStreamSnapshots();
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
                onPressed: () => _authService.signOut(),
                icon: const Icon(Icons.account_circle_rounded),
                color: Colors.white,
              ),
            ],
            bottom: SearchFilterRestaurants(
                searchableRestaurants: _allResults,
                updateResults: updateResults),
          ),
          CupertinoSliverRefreshControl(
            onRefresh: _onPullRefresh,
          ),
          RestaurantList(restaurantsList: _resultsList)
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-restaurant');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
