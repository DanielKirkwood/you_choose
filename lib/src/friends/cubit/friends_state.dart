part of 'friends_cubit.dart';

enum FriendCubitStatus { initial, loading, success, failure }

class FriendsState extends Equatable {
  const FriendsState({required this.status});

  final FriendCubitStatus status;

  FriendsState copyWith({FriendCubitStatus? status}) {
    return FriendsState(status: status ?? this.status);
  }

  @override
  List<Object> get props => [status];
}
