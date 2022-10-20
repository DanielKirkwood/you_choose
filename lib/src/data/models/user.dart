// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';


/// {@template user}
/// User model
///
/// [UserModel.empty()] represents an unauthenticated user.
/// {@endtemplate}
class UserModel extends Equatable {
  /// {@macro user}
  const UserModel(
      {required this.uid,
      required this.username,
      required this.email,
      required this.isVerified,
      required this.useDefaultProfileImage,
      required this.friends});

  /// the current user's id.
  final String uid;

  /// the current user's username.
  final String username;

  /// the current user's email address.
  final String email;

  /// true if user's email address is verified, false otherwise.
  final bool isVerified;

  /// true if user has not set profile image, false otherwise.
  final bool useDefaultProfileImage;

  /// the users friends list
  final Map<String, dynamic> friends;

  /// Empty user which represents an unauthenticated user.
  const UserModel.empty()
      : uid = "",
        username = "",
        email = "",
        isVerified = false,
        useDefaultProfileImage = true,
        friends = const {};

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == const UserModel.empty();

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != const UserModel.empty();

  /// Convenience copyWith method to update fields
  UserModel copyWith({
    String? uid,
    String? username,
    String? email,
    bool? isVerified,
    bool? useDefaultProfileImage,
    Map<String, dynamic>? friends,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      email: email ?? this.email,
      isVerified: isVerified ?? this.isVerified,
      useDefaultProfileImage:
          useDefaultProfileImage ?? this.useDefaultProfileImage,
      friends: friends ?? this.friends,
    );
  }

  /// Method for creating [UserModel] from firestore document.
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
        useDefaultProfileImage: data?['useDefaultProfileImage'],
        friends: data?['friends']);
  }

  /// Method for adding [UserModel] to firestore.
  Map<String, dynamic> toFirestore() {
    return {
      "username": username,
      "email": email,
      "isVerified": isVerified,
      "useDefaultProfileImage": useDefaultProfileImage,
      "friends": friends
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
      friends
    ];
  }

  @override
  bool get stringify => true;
}
