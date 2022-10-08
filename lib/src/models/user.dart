// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String uid;
  final String username;
  final String email;
  final bool isVerified;
  final bool useDefaultProfileImage;

  const UserModel(
      {required this.uid,
      required this.username,
      required this.email,
      required this.isVerified,
      required this.useDefaultProfileImage});

  const UserModel.empty()
      : uid = "",
        username = "",
        email = "",
        isVerified = false,
        useDefaultProfileImage = true;

  UserModel copyWith({
    String? uid,
    String? username,
    String? email,
    bool? isVerified,
    bool? useDefaultProfileImage,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      email: email ?? this.email,
      isVerified: isVerified ?? this.isVerified,
      useDefaultProfileImage:
          useDefaultProfileImage ?? this.useDefaultProfileImage,
    );
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
        useDefaultProfileImage: data?['useDefaultProfileImage']
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "username": username,
      "email": email,
      "isVerified": isVerified,
      "useDefaultProfileImage": useDefaultProfileImage
    };
  }

  @override
  List<Object> get props {
    return [
      uid,
      username,
      email,
      isVerified,
      useDefaultProfileImage,
    ];
  }

  @override
  bool get stringify => true;
}
