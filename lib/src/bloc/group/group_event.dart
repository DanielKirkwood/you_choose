part of 'group_bloc.dart';

abstract class GroupEvent extends Equatable {
  const GroupEvent();

  @override
  List<Object> get props => [];
}

class LoadGroups extends GroupEvent {
  const LoadGroups();

  @override
  List<Object> get props => [];
}

class UpdateGroups extends GroupEvent {
  final List<Group> groups;

  const UpdateGroups(this.groups);

  @override
  List<Object> get props => [groups];
}

class AddGroup extends GroupEvent {
  final String name;
  final List<String> groupMembers;

  const AddGroup({required this.name, required this.groupMembers});

  @override
  List<Object> get props => [name, groupMembers];
}

class DeleteGroup extends GroupEvent {
  final Group group;

  const DeleteGroup(this.group);

  @override
  List<Object> get props => [group];
}
