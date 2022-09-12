part of 'database_bloc.dart';

abstract class DatabaseEvent extends Equatable {
  const DatabaseEvent();

  @override
  List<Object?> get props => [];
}

class DatabaseFetched extends DatabaseEvent {
  final String? username;
  const DatabaseFetched(this.username);

  @override
  List<Object?> get props => [username];
}
