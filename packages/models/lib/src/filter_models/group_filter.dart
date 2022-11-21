import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

/// {@template groupFilter}
/// A single group filter status.
/// {@endtemplate}
class GroupFilter extends Equatable {
  /// {@macro groupFilter}
  const GroupFilter({
    required this.name,
    required this.group,
    required this.value,
  });

  /// the name of the group.
  final String name;

  /// the [Group] object.
  final Group group;

  /// the value
  final bool value;

  /// convenience copyWith method.
  GroupFilter copyWith({
    String? name,
    Group? group,
    bool? value,
  }) {
    return GroupFilter(
      name: name ?? this.name,
      group: group ?? this.group,
      value: value ?? this.value,
    );
  }

  /// created a list of filters from a given list of groups.
  static List<GroupFilter> getFilters(List<Group> groups) {
    return groups
        .map(
          (group) => GroupFilter(
            name: group.name,
            group: group,
            value: false,
          ),
        )
        .toList();
  }

  @override
  List<Object?> get props => [name, group, value];
}
