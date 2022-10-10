import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:you_choose/src/data/data.dart';

/// {@template group}
/// A single group.
///
/// Contains a [name], list of [members], list of [restaurants], list of [tags] and [id]
///
/// [Group]s are immutable and can be copied using [copyWith].
/// respectively.
/// {@endtemplate}
@immutable
class Group extends Equatable {
  /// {@macro group}
  const Group({
    required this.id,
    required this.name,
    required this.members,
    this.restaurants = const <Restaurant>[],
    this.tags = const <Tag>[],
  });

  /// The unique identifier of the group.
  final String id;

  /// The name of the group.
  final String name;

  /// List of user id's who are in this group.
  final List<String> members;

  /// List of [Restaurant]s within the group.
  final List<Restaurant>? restaurants;

  /// List of [Tag]s created for the group.
  final List<Tag>? tags;

  /// Empty group which represents an uncreated group.
  const Group.empty()
      : id = "",
        name = "",
        members = const <String>[],
        restaurants = const <Restaurant>[],
        tags = const <Tag>[];

  /// Convenience getter to determine whether the current group is empty.
  bool get isEmpty => this == const Group.empty();

  /// Convenience getter to determine whether the current group is not empty.
  bool get isNotEmpty => this != const Group.empty();

  /// Convenience copyWith method to update fields
  ///
  /// {@macro group}
  Group copyWith({
    String? id,
    String? name,
    List<String>? members,
    List<Restaurant>? restaurants,
    List<Tag>? tags,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      members: members ?? this.members,
      restaurants: restaurants ?? this.restaurants,
      tags: tags ?? this.tags,
    );
  }

  /// Method for creating [Group] from firestore document.
  factory Group.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return Group(
        name: data?['name'],
        members:
            data?['members'] is Iterable ? List.from(data?['members']) : [],
        id: snapshot.id);
  }

  /// Method for adding [Group] to firestore.
  Map<String, dynamic> toFirestore() {
    return {"name": name, "members": members, "id": id};
  }

  @override
  List<Object?> get props => [id, name, members, restaurants, tags];

  @override
  bool get stringify => true;
}
