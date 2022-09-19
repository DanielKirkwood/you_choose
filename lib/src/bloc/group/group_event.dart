part of 'group_bloc.dart';

abstract class GroupEvent extends Equatable {
  const GroupEvent();

  @override
  List<Object> get props => [];
}

class LoadGroups extends GroupEvent {
  final String userID;

  const LoadGroups(this.userID);

  @override
  List<Object> get props => [userID];
}

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

class DeleteGroup extends GroupEvent {
  final Group group;

  const DeleteGroup(this.group);

  @override
  List<Object> get props => [group];
}
