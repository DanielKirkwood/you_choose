part of 'group_cubit.dart';

/// enum representing the states which the [GroupCubit] can be in.
///
/// [initial] - is the base state.
///
/// [loading] - intermediate state used while [GroupCubit] interacts with backend.
///
/// [success] - action carried out successfully and state has been updated with changes.
///
/// [failure] - action has failed.
///
/// [adding] - new group is being added to groups.
enum GroupStatus { initial, loading, success, failure, adding }

/// {@template groupState}
/// A single state used to hold state about groups.
///
/// Contains the [status] of the state and the list of [Group]s for frontend.
/// {@endtemplate}
class GroupState extends Equatable {
  /// {@macro groupState}
  const GroupState(
      {this.groups = const <Group>[], this.status = GroupStatus.initial});

  /// the list of groups.
  final List<Group> groups;

  /// the status of the state.
  final GroupStatus status;

  /// Convenience copyWith method to update fields
  ///
  /// {@macro groupState}
  GroupState copyWith({List<Group>? groups, GroupStatus? status}) {
    return GroupState(
        groups: groups ?? this.groups, status: status ?? this.status);
  }

  @override
  List<Object> get props => [groups, status];
}
