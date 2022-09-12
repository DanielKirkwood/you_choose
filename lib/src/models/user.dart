import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? username;
  String? email;
  bool? isVerified;
  String? password;

  UserModel({
    this.uid,
    this.username,
    this.email,
    this.isVerified,
    this.password,
  });

  @override
  String toString() {
    return "uid: $uid, username: $username, email: $email";
  }

  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? options,
  ) {
    final data = doc.data();

    return UserModel(
      uid: doc.id,
      username: data?['username'],
      email: data?['email'],
      isVerified: data?['isVerified'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "username": username,
      "uid": uid,
      "email": email,
      "isVerified": isVerified,
    };
  }

  UserModel copyWith({
    bool? isVerified,
    String? username,
    String? uid,
    String? email,
    String? password,
  }) {
    return UserModel(
        uid: uid ?? this.uid,
        email: email ?? this.email,
        username: username ?? this.username,
        isVerified: isVerified ?? this.isVerified,
        password: password ?? this.password);
  }
}
