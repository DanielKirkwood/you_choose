import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:you_choose/src/data/data.dart';
import 'package:you_choose/src/repositories/database/database_repository.dart';
import 'package:you_choose/src/util/logger/logger.dart';

class FirestoreRepository implements DatabaseRepository {
  final FirebaseFirestore _db;
  final FirebaseStorage _storage;
  var logger = getLogger('DatabaseRepositoryImpl');

  FirestoreRepository(
      {FirebaseFirestore? firebaseFirestore, FirebaseStorage? firebaseStorage})
      : _db = firebaseFirestore ?? FirebaseFirestore.instance,
        _storage = firebaseStorage ?? FirebaseStorage.instance;

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
  Future<UserModel> getUser({required String email}) async {
    QuerySnapshot<UserModel> snapshot = await _db
        .collection('users')
        .withConverter(
            fromFirestore: UserModel.fromFirestore,
            toFirestore: (UserModel user, options) => user.toFirestore())
        .where('email', isEqualTo: email)
        .get();

    return snapshot.docs.first.data();
  }

  @override
  Future<List<Restaurant>> getRestaurantData(String groupID) async {
    List<Restaurant> restaurants = [];

    final groupDocument = _db.collection('groups').doc(groupID);

    final restaurantsCollection = groupDocument
        .collection('restaurants')
        .withConverter(
            fromFirestore: Restaurant.fromFirestore,
            toFirestore: (Restaurant restaurant, options) =>
                restaurant.toFirestore());

    final restaurantQuery = await restaurantsCollection.get();

    for (var i = 0; i < restaurantQuery.size; i++) {
      String restaurantId = restaurantQuery.docs[i].id;
      Restaurant restaurant = restaurantQuery.docs[i].data();
      List<Tag> tags = [];

      final tagsCollection = groupDocument
          .collection('restaurants')
          .doc(restaurantId)
          .collection('tags')
          .withConverter(
              fromFirestore: Tag.fromFirestore,
              toFirestore: (Tag tag, options) => tag.toFirestore());

      QuerySnapshot<Tag> tagQuery = await tagsCollection.get();

      for (var i = 0; i < tagQuery.size; i++) {
        tags.add(tagQuery.docs[i].data());
      }

      restaurant = restaurant.copyWith(tags: tags);
      restaurants.add(restaurant);
    }

    return restaurants;
  }

  @override
  Future<List<Group>> getUserGroupData(String uid) async {
    List<Group> groups = await retrieveUserGroupsOnly(uid);

    for (Group group in groups) {
      List<Restaurant> restaurants = await retrieveGroupRestaurants(group.id);

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

  Future<List<Restaurant>> retrieveGroupRestaurants(String? id) async {
    List<Restaurant> restaurants = [];

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

  @override
  Future<void> addRestaurant(
      {required Restaurant restaurant, required List<Group> groups}) async {
    try {
      for (Group group in groups) {
        CollectionReference<Restaurant> restaurantsCollection = _db
            .collection('groups')
            .doc(group.id)
            .collection('restaurants')
            .withConverter(
                fromFirestore: Restaurant.fromFirestore,
                toFirestore: (Restaurant restaurant, options) =>
                    restaurant.toFirestore());

        restaurantsCollection.add(restaurant).then((doc) {
          if (restaurant.tags != null) {
            CollectionReference<Tag> tagsCollection = doc
                .collection('tags')
                .withConverter(
                    fromFirestore: Tag.fromFirestore,
                    toFirestore: (Tag tag, options) => tag.toFirestore());

            for (Tag tag in restaurant.tags!) {
              tagsCollection.add(tag);
            }
          }
        });
      }
    } catch (error) {
      logger.e(error.toString());
      rethrow;
    }
  }

  Future<String> getProfileImage(String uid) async {
    var storageRef = _storage.ref().child('user/profile/$uid');

    return storageRef.getDownloadURL();
  }

  /// The user selects a file, and the task is added to the list.
  Future<UploadTask> uploadFile(XFile file, String uid) async {
    UploadTask uploadTask;

    // Create a Reference to the file
    Reference ref =
        _storage.ref().child('user').child('profile').child("$uid.jpg");

    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': file.path},
    );

    uploadTask = ref.putFile(File(file.path), metadata);

    return Future.value(uploadTask);
  }

  Future<void> updateProfileImage(XFile image, String uid) async {
    await uploadFile(image, uid);
  }

  Future<List<Tag>> getGroupTags({required String groupID}) async {
    List<Tag> tags = [];
    try {
      QuerySnapshot<Tag> snapshot = await _db
          .collection('groups')
          .doc(groupID)
          .collection('tags')
          .withConverter(
              fromFirestore: Tag.fromFirestore,
              toFirestore: (Tag tag, options) => tag.toFirestore())
          .get();

      for (var i = 0; i < snapshot.size; i++) {
        tags.add(snapshot.docs[i].data());
      }

      return tags;
    } catch (error) {
      logger.e(error.toString());
      rethrow;
    }
  }

  Future<Tag> addGroupTag({required Tag tag, required String groupID}) async {
    try {
      DocumentReference<Tag> tagDoc = _db
          .collection('groups')
          .doc(groupID)
          .collection('tags')
          .withConverter(
              fromFirestore: Tag.fromFirestore,
              toFirestore: (Tag tag, options) => tag.toFirestore())
          .doc();

      String documentID = tagDoc.id;
      Tag updatedTag = tag.copyWith(id: documentID);

      await tagDoc.set(updatedTag);

      return updatedTag;
    } catch (error) {
      logger.e(error.toString());
      rethrow;
    }
  }

  Future<void> sendFriendRequest(
      {required String friendID, required String userID}) async {
    try {
      final friendDoc = _db.collection('users').doc(friendID);

      await friendDoc.update({
        "friends": FieldValue.arrayUnion([
          {userID: FriendStatus.incomingRequest}
        ])
      });

      final userDoc = _db.collection('users').doc(userID);

      await userDoc.update({
        "friends": FieldValue.arrayUnion([
          {friendID: FriendStatus.requested}
        ])
      });
    } catch (error) {
      logger.e(error.toString());
      rethrow;
    }
  }

  Future<void> acceptFriendRequest(
      {required String friendID, required String userID}) async {
    try {
      final friendDoc = _db.collection('users').doc(friendID);

      await friendDoc.update({
        "friends": FieldValue.arrayUnion([
          {userID: FriendStatus.friend}
        ])
      });

      final userDoc = _db.collection('users').doc(userID);

      await userDoc.update({
        "friends": FieldValue.arrayUnion([
          {friendID: FriendStatus.friend}
        ])
      });
    } catch (error) {
      logger.e(error.toString());
      rethrow;
    }
  }

  Future<void> declineFriendRequest(
      {required String friendID, required String userID}) async {
    try {
      final friendDoc = _db.collection('users').doc(friendID);

      await friendDoc.update({
        "friends": FieldValue.arrayRemove([
          {userID: FriendStatus.incomingRequest}
        ])
      });

      final userDoc = _db.collection('users').doc(userID);

      await userDoc.update({
        "friends": FieldValue.arrayRemove([
          {friendID: FriendStatus.requested}
        ])
      });
    } catch (error) {
      logger.e(error.toString());
      rethrow;
    }
  }
}
