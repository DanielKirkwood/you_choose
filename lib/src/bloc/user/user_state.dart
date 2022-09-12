part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserSuccess extends UserState {
  final List<UserModel?> userList;
  final String? username;

  const UserSuccess(this.userList, this.username);

  @override
  List<Object?> get props => [userList, username];
}

class UserError extends UserState {
  @override
  List<Object?> get props => [];
}
