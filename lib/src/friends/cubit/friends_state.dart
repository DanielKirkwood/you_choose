part of 'friends_cubit.dart';

enum FriendCubitStatus { initial, loading, success, failure }

class FriendsState extends Equatable {
  const FriendsState(
      {required this.friends,
      required this.friendRequests,
      required this.status});

  final List<String> friends;

  final List<String> friendRequests;

  final FriendCubitStatus status;

  FriendsState copyWith(
      {List<String>? friends,
      List<String>? friendRequests,
      FriendCubitStatus? status}) {
    return FriendsState(
        friends: friends ?? this.friends,
        friendRequests: friendRequests ?? this.friendRequests,
        status: status ?? this.status);
  }

  @override
  List<Object> get props => [friends, friendRequests, status];
}
