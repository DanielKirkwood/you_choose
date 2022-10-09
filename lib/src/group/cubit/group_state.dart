part of 'group_cubit.dart';

enum GroupStatus { initial, loading, success, failure }

class GroupState extends Equatable {
  final List<Group> groups;
  final GroupStatus status;

  const GroupState(
      {this.groups = const <Group>[], this.status = GroupStatus.initial});

  @override
  List<Object> get props => [groups, status];

  GroupState copyWith({
    List<Group>? groups,
    GroupStatus? status
  }) {
    return GroupState(
        groups: groups ?? this.groups, status: status ?? this.status);
  }
}
