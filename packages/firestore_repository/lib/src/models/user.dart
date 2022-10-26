import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// {@template UserModel}
/// UserModel model
///
/// [UserModel.empty()] represents an unauthenticated UserModel.
/// {@endtemplate}
class UserModel extends Equatable {
  /// {@macro UserModel}
  const UserModel({
    required this.username,
    required this.email,
    required this.isVerified,
    required this.friends,
  });

  /// Method for creating [UserModel] from firestore document.
  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
    // ignore: avoid_unused_constructor_parameters
    SnapshotOptions? options,
  ) {
    final data = doc.data();

    return UserModel(
      username: doc.id,
      email: data?['email'] as String,
      isVerified: data?['isVerified'] as bool,
      friends: data?['friends'] as Map<String, dynamic>,
    );
  }

  /// the current UserModel's username.
  final String username;

  /// the current UserModel's email address.
  final String email;

  /// true if UserModel's email address is verified, false otherwise.
  final bool isVerified;

  /// the UserModels friends list
  final Map<String, dynamic> friends;

  /// Empty UserModel which represents an unauthenticated UserModel.
  static const empty =
      UserModel(username: '', email: '', isVerified: false, friends: {});

  /// Convenience getter to determine whether the current UserModel is empty.
  bool get isEmpty => this == UserModel.empty;

  /// Convenience getter to determine whether the current UserModel is not empty.
  bool get isNotEmpty => this != UserModel.empty;

  /// Method for adding [UserModel] to firestore.
  Map<String, dynamic> toFirestore() {
    return {
      'username': username,
      'email': email,
      'isVerified': isVerified,
      'friends': friends
    };
  }

  /// Convenience copyWith method to update fields
  UserModel copyWith({
    String? username,
    String? email,
    bool? isVerified,
    Map<String, dynamic>? friends,
  }) {
    return UserModel(
      username: username ?? this.username,
      email: email ?? this.email,
      isVerified: isVerified ?? this.isVerified,
      friends: friends ?? this.friends,
    );
  }

  @override
  List<Object> get props {
    return [username, email, isVerified, friends];
  }

  @override
  bool get stringify => true;
}
