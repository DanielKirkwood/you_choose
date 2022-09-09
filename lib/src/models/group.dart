import 'package:cloud_firestore/cloud_firestore.dart';


class Group {
  String name;
  List<String> members;
  CollectionReference? restaurants;

  Group({required this.name, required this.members, this.restaurants});

  @override
  String toString() {
    return "name: $name, members: ${members.toString()}, restaurants: ${restaurants.toString()}";
  }

  factory Group.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return Group(
      name: data?['name'],
      members:
          data?['members'] is Iterable ? List.from(data?['members']) : [],
      restaurants: data?['restaurants'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "members": members,
      if (restaurants != null) "restaurants": restaurants
    };
  }
}
