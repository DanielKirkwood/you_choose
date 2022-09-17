part of 'group_bloc.dart';

abstract class GroupState extends Equatable {
  const GroupState();

  @override
  List<Object?> get props => [];
}

class GroupLoading extends GroupState {
  @override
  List<Object?> get props => [];
}

class GroupLoaded extends GroupState {
  final List<Group>? groups;

  const GroupLoaded({this.groups});

  @override
  List<Object?> get props => [groups];
}

class GroupError extends GroupState {
  final Group? errorGroup;

  const GroupError({this.errorGroup});
  @override
  List<Object?> get props => [];
}
