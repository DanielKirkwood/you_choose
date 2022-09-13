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
    await _db.collection("users").doc(user.uid).set(user.toFirestore());
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

    snapshot.docs.map(
        (DocumentSnapshot<UserModel> userDoc) => users.add(userDoc.data()));

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

    snapshot.docs.map((DocumentSnapshot<Restaurant> restaurantDoc) =>
        restaurants.add(restaurantDoc.data()));

    return restaurants;
  }

  @override
  Future<List<Group?>> getUserGroupData(String uid) async {
    List<Group?> groups = await retrieveUserGroupsOnly(uid);

    for (Group? group in groups) {
      List<Restaurant?> restaurants = await retrieveGroupRestaurants(group!.id);

      group.copyWith(restaurants: restaurants);
    }

    return groups;
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
}
