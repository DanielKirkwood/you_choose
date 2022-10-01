// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:you_choose/src/models/models.dart';

class Group extends Equatable {
  final String? id;
  final String? name;
  final List<String>? members;
  final List<Restaurant?>? restaurants;
  final List<Tag>? tags;

  const Group({
    this.id,
    this.name,
    this.members,
    this.restaurants,
    this.tags,
  });



  factory Group.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return Group(
      name: data?['name'],
      members:
            data?['members'] is Iterable ? List.from(data?['members']) : [],
        id: snapshot.id
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (members != null) "members": members,
      if (id != null) "id": id
    };
  }


  Group copyWith({
    String? id,
    String? name,
    List<String>? members,
    List<Restaurant?>? restaurants,
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

  @override
  String toString() {
    return 'Group(id: $id, name: $name, members: $members, restaurants: $restaurants, tags: $tags)';
  }

  @override
  List<Object?> get props => [id, name, members, restaurants, tags];
}
