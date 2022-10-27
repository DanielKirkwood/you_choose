import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// {@template UserModel}
/// UserModel model
///
/// [UserModel.empty()] represents an unauthenticated UserModel.
/// {@endtemplate}
@immutable
class UserModel extends Equatable {
  /// {@macro UserModel}
  const UserModel({
    required this.username,
    required this.email,
    required this.isVerified,
    required this.friends,
  });

  /// Method for creating [UserModel] from JSON.
  factory UserModel.fromJson(
    String id,
    Map<String, dynamic>? data,
  ) {
    return UserModel(
      username: id,
      email: data?['email'] as String,
      isVerified: data?['isVerified'] as bool,
      friends: data?['friends'] as Map<String, dynamic>,
    );
  }

  /// Method for adding [UserModel] to json.
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'isVerified': isVerified,
      'friends': friends
    };
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

  /// Convenience getter to determine whether the current UserModel
  /// is not empty.
  bool get isNotEmpty => this != UserModel.empty;

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
