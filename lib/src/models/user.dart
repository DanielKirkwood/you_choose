import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String username;
  final String uid;

  AppUser({required this.username, required this.uid});


  @override
  String toString() {
    return "username: $username, uid: $uid";
  }

  factory AppUser.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return AppUser(
        username: data?['username'],
        uid: data?['uid']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      "username": username,
      "uid": uid
    };
  }

}
