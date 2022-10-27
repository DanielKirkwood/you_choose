part of 'friends_cubit.dart';

enum FriendStatus { initial, loading, success, failure }

class FriendsState extends Equatable {
  const FriendsState(
      {this.friends = const [],
      this.friendRequests = const [],
      this.status = FriendStatus.initial,
      this.username = const Username.pure(),
      this.formStatus = FormzStatus.pure,
    this.errorMessage,
  });

  final List<String> friends;

  final List<String> friendRequests;

  final FriendStatus status;

  final Username username;

  final FormzStatus formStatus;

  final String? errorMessage;

  FriendsState copyWith(
      {List<String>? friends,
      List<String>? friendRequests,
    FriendStatus? status,
    Username? username,
    FormzStatus? formStatus,
    String? errorMessage,
  }) {
    return FriendsState(
        friends: friends ?? this.friends,
        friendRequests: friendRequests ?? this.friendRequests,
        status: status ?? this.status,
        username: username ?? this.username,
        formStatus: formStatus ?? this.formStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props =>
      [friends, friendRequests, status, username, formStatus];
}
