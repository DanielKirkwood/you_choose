part of 'friends_cubit.dart';

enum FriendStatus { initial, loading, success, failure }

class FriendsState extends Equatable {
  const FriendsState({required this.status});

  final FriendStatus status;

  FriendsState copyWith({FriendStatus? status}) {
    return FriendsState(status: status ?? this.status);
  }

  @override
  List<Object> get props => [status];
}
