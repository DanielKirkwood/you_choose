import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? username;
  String? email;
  bool? isVerified;
  String? password;
  String? profileImage;

  UserModel({
    this.uid,
    this.username,
    this.email,
    this.isVerified,
    this.password,
      this.profileImage
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
      profileImage: data?['profileImage'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "username": username,
      "uid": uid,
      "email": email,
      "isVerified": isVerified,
      "profileImage": profileImage,
    };
  }

  UserModel copyWith({
    bool? isVerified,
    String? username,
    String? uid,
    String? email,
    String? password,
    String? profileImage,
  }) {
    return UserModel(
        uid: uid ?? this.uid,
        email: email ?? this.email,
        username: username ?? this.username,
        isVerified: isVerified ?? this.isVerified,
        password: password ?? this.password,
        profileImage: profileImage ?? this.profileImage);
  }
}
