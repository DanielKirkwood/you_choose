import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:models/models.dart';

/// {@template group}
/// A single group.
///
/// Contains a [name], list of [members], list of [restaurants], list of [tags]
/// and [docID]
///
/// [Group]s are immutable and can be copied using [copyWith].
/// respectively.
/// {@endtemplate}
@immutable
class Group extends Equatable {
  /// {@macro group}
  const Group({
    required this.name,
    required this.members,
    this.restaurants,
    this.tags,
    this.docID,
  });

  /// Method for creating [Group] from JSON
  factory Group.fromJson(
    String id,
    Map<String, dynamic>? data,
  ) {
    return Group(
      name: data?['name'] as String,
      members: data?['members'] is Iterable
          ? List.from(data?['members'] as Iterable)
          : [],
      docID: id,
    );
  }

  /// Method for adding [Group] to firestore.
  Map<String, dynamic> toJson() {
    return {'name': name, 'members': members};
  }

  /// The name of the group.
  final String name;

  /// List of user id's who are in this group.
  final List<String> members;

  /// List of [Restaurant]s within the group.
  final List<Restaurant>? restaurants;

  /// List of [Tag]s created for the group.
  final List<Tag>? tags;

  /// The unique identifier of the group.
  final String? docID;

  /// Empty group which represents an uncreated group.
  static const empty = Group(
    name: '',
    members: [],
  );

  /// Convenience getter to determine whether the current group is empty.
  bool get isEmpty => this == Group.empty;

  /// Convenience getter to determine whether the current group is not empty.
  bool get isNotEmpty => this != Group.empty;

  /// Convenience copyWith method to update fields
  ///
  /// {@macro group}
  Group copyWith({
    String? name,
    List<String>? members,
    List<Restaurant>? restaurants,
    List<Tag>? tags,
    String? docID,
  }) {
    return Group(
      name: name ?? this.name,
      members: members ?? this.members,
      restaurants: restaurants ?? this.restaurants,
      tags: tags ?? this.tags,
      docID: docID ?? this.docID,
    );
  }

  @override
  List<Object?> get props => [name, members, restaurants, tags, docID];

  @override
  bool get stringify => true;
}
