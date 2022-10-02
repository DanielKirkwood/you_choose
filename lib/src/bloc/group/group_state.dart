part of 'group_bloc.dart';

abstract class GroupState extends Equatable {
  const GroupState();

  @override
  List<Object?> get props => [];
}

class GroupInitial extends GroupState {
  @override
  List<Object?> get props => [];
}

class GroupLoading extends GroupState {
  @override
  List<Object?> get props => [];
}

class GroupLoaded extends GroupState {
  final List<Group> groups;

  const GroupLoaded({required this.groups});

  @override
  List<Object> get props => [groups];
}

class GroupAdded extends GroupState {
  final Group newGroup;

  const GroupAdded({required this.newGroup});

  @override
  List<Object?> get props => [newGroup];
}

class GroupDeleted extends GroupState {
  final Group group;

  const GroupDeleted({required this.group});

  @override
  List<Object> get props => [group];
}

class GroupError extends GroupState {
  final Group? errorGroup;

  const GroupError({this.errorGroup});
  @override
  List<Object?> get props => [];
}
