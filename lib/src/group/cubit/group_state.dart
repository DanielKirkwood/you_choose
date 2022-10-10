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
enum GroupStatus { initial, loading, success, failure }

/// {@template groupState}
/// A single state used to hold state about groups.
///
/// Contains the [status] of the state and the list of [Group]s for frontend.
/// {@endtemplate}
class GroupState extends Equatable {
  /// {@macro groupState}
  const GroupState(
      {this.groups = const <Group>[],
      this.status = GroupStatus.initial,
      this.name = const GroupName.pure(),
      this.members = const GroupMembers.pure(),
      this.formStatus = FormzStatus.pure,
      this.errorMessage});

  /// the list of groups.
  final List<Group> groups;

  /// the status of the state.
  final GroupStatus status;

  /// the new group name.
  final GroupName name;

  /// the new group members.
  final GroupMembers members;

  final FormzStatus formStatus;

  final String? errorMessage;


  /// Convenience copyWith method to update fields
  ///
  /// {@macro groupState}
  GroupState copyWith({
    List<Group>? groups,
    GroupStatus? status,
    GroupName? name,
    GroupMembers? members,
    FormzStatus? formStatus,
    String? errorMessage,
  }) {
    return GroupState(
        groups: groups ?? this.groups,
        status: status ?? this.status,
        name: name ?? this.name,
        members: members ?? this.members,
        formStatus: formStatus ?? this.formStatus,
        errorMessage: errorMessage ?? this.errorMessage);
  }

  @override
  List<Object> get props => [groups, status, name, members];
}
