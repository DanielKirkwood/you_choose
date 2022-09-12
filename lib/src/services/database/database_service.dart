import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:you_choose/src/models/group.dart';
import 'package:you_choose/src/models/restaurant.dart';
import 'package:you_choose/src/models/user.dart';
import 'package:you_choose/src/util/logger/logger.dart';

class DatabaseService {
  final FirebaseFirestore _db;
  var logger = getLogger('DatabaseService');

  DatabaseService({FirebaseFirestore? firebaseFirestore})
      : _db = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<void> addUserData(UserModel userData) async {
    logger.i('*** addUserData ***');
    logger.i('doc id - ${userData.uid}');
    logger.i('userData - $userData');
    await _db.collection("users").doc(userData.uid).set(userData.toFirestore());
  }

  Future<List<UserModel?>> retrieveUserData() async {
    logger.i('*** retrieveUserData ***');

    List<UserModel?> users = [];

    QuerySnapshot<UserModel> snapshot = await _db
        .collection("users")
        .withConverter(
            fromFirestore: UserModel.fromFirestore,
            toFirestore: (UserModel user, options) => user.toFirestore())
        .get();

    snapshot.docs.map(
        (DocumentSnapshot<UserModel> userDoc) => users.add(userDoc.data()));

    return users;
  }

  Future<String?> retrieveUserName(UserModel user) async {
    logger.i('*** retrieveUserName ***');

    DocumentSnapshot<UserModel> snapshot = await _db
        .collection('users')
        .doc(user.uid)
        .withConverter(
            fromFirestore: UserModel.fromFirestore,
            toFirestore: (UserModel user, options) => user.toFirestore())
        .get();

    return snapshot.data()!.username;
  }

  Future<List<Restaurant?>> retrieveRestaurantData() async {
    List<Restaurant?> restaurants = [];

    QuerySnapshot<Restaurant> snapshot = await _db
        .collection('restaurants')
        .withConverter(
            fromFirestore: Restaurant.fromFirestore,
            toFirestore: (Restaurant restaurant, options) =>
                restaurant.toFirestore())
        .get();

    snapshot.docs.map((DocumentSnapshot<Restaurant> restaurantDoc) =>
        restaurants.add(restaurantDoc.data()));

    return restaurants;
  }

  Future<List<Restaurant?>> retrieveGroupRestaurants(String? id) async {
    List<Restaurant?> restaurants = [];

    QuerySnapshot<Restaurant> restaurantSnapshot = await _db
        .collection('groups')
        .doc(id)
        .collection('restaurants')
        .withConverter(
            fromFirestore: Restaurant.fromFirestore,
            toFirestore: (Restaurant restaurant, options) =>
                restaurant.toFirestore())
        .get();

    restaurantSnapshot.docs.map((DocumentSnapshot<Restaurant> restaurantDoc) =>
        restaurants.add(restaurantDoc.data()));

    return restaurants;
  }

  Future<List<Group?>> retrieveUserGroupsOnly(String uid) async {
    List<Group?> groups = [];

    QuerySnapshot<Group> groupSnapshot = await _db
        .collection('groups')
        .withConverter(
            fromFirestore: Group.fromFirestore,
            toFirestore: (Group group, options) => group.toFirestore())
        .where('members', arrayContains: uid)
        .get();

    groupSnapshot.docs
        .map((DocumentSnapshot<Group> groupDoc) => groups.add(groupDoc.data()));

    return groups;
  }

  Future<List<Group?>> retrieveUsersGroupData(String uid) async {
    List<Group?> groups = await retrieveUserGroupsOnly(uid);

    for (Group? group in groups) {
      List<Restaurant?> restaurants = await retrieveGroupRestaurants(group!.id);

      group.copyWith(restaurants: restaurants);
    }

    return groups;
  }
}
