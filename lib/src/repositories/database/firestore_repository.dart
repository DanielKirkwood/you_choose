import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:you_choose/src/models/models.dart';
import 'package:you_choose/src/repositories/database/database_repository.dart';
import 'package:you_choose/src/util/logger/logger.dart';

class FirestoreRepository implements DatabaseRepository {
  final FirebaseFirestore _db;
  var logger = getLogger('DatabaseRepositoryImpl');

  FirestoreRepository({FirebaseFirestore? firebaseFirestore})
      : _db = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<void> addUserData(UserModel user) async {
    try {
      await _db.collection("users").doc(user.uid).set(user.toFirestore());
    } on FirebaseException {
      rethrow;
    }
  }

  @override
  Future<List<UserModel?>> getUserData() async {
    List<UserModel?> users = [];

    QuerySnapshot<UserModel> snapshot = await _db
        .collection("users")
        .withConverter(
            fromFirestore: UserModel.fromFirestore,
            toFirestore: (UserModel user, options) => user.toFirestore())
        .get();

    for (var i = 0; i < snapshot.size; i++) {
      users.add(snapshot.docs[i].data());
    }

    return users;
  }

  @override
  Future<UserModel?> getUser(UserModel user) async {
    if (user.uid != null) {
      DocumentSnapshot<UserModel> snapshot = await _db
          .collection('users')
          .doc(user.uid)
          .withConverter(
              fromFirestore: UserModel.fromFirestore,
              toFirestore: (UserModel user, options) => user.toFirestore())
          .get();



      return snapshot.data();
    } else if (user.email != null) {
      QuerySnapshot<UserModel> snapshot = await _db
          .collection('users')
          .withConverter(
              fromFirestore: UserModel.fromFirestore,
              toFirestore: (UserModel user, options) => user.toFirestore())
          .where('email', isEqualTo: user.email)
          .get();

      return snapshot.docs.first.data();
    } else if (user.username != null) {
      QuerySnapshot<UserModel> snapshot = await _db
          .collection('users')
          .withConverter(
              fromFirestore: UserModel.fromFirestore,
              toFirestore: (UserModel user, options) => user.toFirestore())
          .where('username', isEqualTo: user.username)
          .get();

      return snapshot.docs.first.data();
    } else {
      return null;
    }
  }

  @override
  Future<List<Restaurant?>> getRestaurantData() async {
    List<Restaurant?> restaurants = [];

    QuerySnapshot<Restaurant> snapshot = await _db
        .collection('restaurants')
        .withConverter(
            fromFirestore: Restaurant.fromFirestore,
            toFirestore: (Restaurant restaurant, options) =>
                restaurant.toFirestore())
        .get();

    for (var i = 0; i < snapshot.size; i++) {
      restaurants.add(snapshot.docs[i].data());
    }

    return restaurants;
  }

  @override
  Future<List<Group>> getUserGroupData(String uid) async {
    List<Group> groups = await retrieveUserGroupsOnly(uid);

    for (Group group in groups) {
      List<Restaurant?> restaurants = await retrieveGroupRestaurants(group.id);

      group.copyWith(restaurants: restaurants);
    }

    logger.d(groups);
    return groups;
  }

  @override
  Future<Group> addGroup(Group group) async {
    try {
      DocumentReference<Group> ref = _db
          .collection('groups')
          .withConverter(
              fromFirestore: Group.fromFirestore,
              toFirestore: (Group group, options) => group.toFirestore())
          .doc();

      String documentID = ref.id;
      Group updatedGroup = group.copyWith(id: documentID);

      await ref.set(updatedGroup);

      return updatedGroup;
    } on FirebaseException {
      rethrow;
    } catch (error) {
      logger.e(error.toString());
      return group;
    }
  }

  Future<List<Restaurant?>> retrieveGroupRestaurants(String? id) async {
    List<Restaurant?> restaurants = [];

    QuerySnapshot<Restaurant> snapshot = await _db
        .collection('groups')
        .doc(id)
        .collection('restaurants')
        .withConverter(
            fromFirestore: Restaurant.fromFirestore,
            toFirestore: (Restaurant restaurant, options) =>
                restaurant.toFirestore())
        .get();

    for (var i = 0; i < snapshot.size; i++) {
      restaurants.add(snapshot.docs[i].data());
    }

    return restaurants;
  }

  Future<List<Group>> retrieveUserGroupsOnly(String uid) async {
    List<Group> groups = [];

    QuerySnapshot<Group> snapshot = await _db
        .collection('groups')
        .withConverter(
            fromFirestore: Group.fromFirestore,
            toFirestore: (Group group, options) => group.toFirestore())
        .where('members', arrayContains: uid)
        .get();

    for (var i = 0; i < snapshot.size; i++) {
      groups.add(snapshot.docs[i].data());
    }

    return groups;
  }
}
