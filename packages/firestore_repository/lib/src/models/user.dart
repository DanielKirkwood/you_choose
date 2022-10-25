import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// {@template user}
/// User model
///
/// [User.empty()] represents an unauthenticated user.
/// {@endtemplate}
class User extends Equatable {
  /// {@macro user}
  const User({
    required this.username,
    required this.email,
    required this.isVerified,
    required this.friends,
  });

  /// Method for creating [User] from firestore document.
  factory User.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
    // ignore: avoid_unused_constructor_parameters
    SnapshotOptions? options,
  ) {
    final data = doc.data();

    return User(
      username: doc.id,
      email: data?['email'] as String,
      isVerified: data?['isVerified'] as bool,
      friends: data?['friends'] as Map<String, dynamic>,
    );
  }

  /// the current user's username.
  final String username;

  /// the current user's email address.
  final String email;

  /// true if user's email address is verified, false otherwise.
  final bool isVerified;

  /// the users friends list
  final Map<String, dynamic> friends;

  /// Empty user which represents an unauthenticated user.
  static const empty =
      User(username: '', email: '', isVerified: false, friends: {});

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == User.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != User.empty;

  /// Method for adding [User] to firestore.
  Map<String, dynamic> toFirestore() {
    return {
      'username': username,
      'email': email,
      'isVerified': isVerified,
      'friends': friends
    };
  }

  /// Convenience copyWith method to update fields
  User copyWith({
    String? username,
    String? email,
    bool? isVerified,
    Map<String, dynamic>? friends,
  }) {
    return User(
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
