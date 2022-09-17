part of 'group_bloc.dart';

abstract class GroupEvent extends Equatable {
  const GroupEvent();

  @override
  List<Object> get props => [];
}

class LoadGroups extends GroupEvent {}

class UpdateGroups extends GroupEvent {
  final List<Group> groups;

  const UpdateGroups(this.groups);

  @override
  List<Object> get props => [groups];
}

class AddGroup extends GroupEvent {
  final Group newGroup;

  const AddGroup(this.newGroup);

  @override
  List<Object> get props => [newGroup];
}
