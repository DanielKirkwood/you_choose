import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:you_choose/src/models/user.dart';
import 'package:you_choose/src/util/logger/logger.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  var logger = getLogger('DatabaseService');

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
}
