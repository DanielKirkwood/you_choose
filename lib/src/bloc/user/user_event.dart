part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class UserFetched extends UserEvent {
  final String? username;
  const UserFetched(this.username);

  @override
  List<Object?> get props => [username];
}
