part of 'database_bloc.dart';

abstract class DatabaseState extends Equatable {
  const DatabaseState();

  @override
  List<Object?> get props => [];
}

class DatabaseInitial extends DatabaseState {}

class DatabaseSuccess extends DatabaseState {
  final List<UserModel?> userList;
  final String? username;

  const DatabaseSuccess(this.userList, this.username);

  @override
  List<Object?> get props => [userList, username];
}

class DatabaseError extends DatabaseState {
  @override
  List<Object?> get props => [];
}
