part of 'group_cubit.dart';

class GroupState extends Equatable {
  final List<Group> groups;

  const GroupState({this.groups = const <Group>[]});

  @override
  List<Object> get props => [groups];

  GroupState copyWith({
    List<Group>? groups,
  }) {
    return GroupState(groups: groups ?? this.groups);
  }
}
