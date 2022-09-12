import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:you_choose/src/models/restaurant.dart';

class Group {
  String? id;
  String? name;
  List<String>? members;
  List<Restaurant?>? restaurants;

  Group({this.name, this.members, this.restaurants, this.id});

  @override
  String toString() {
    return "id: $id, name: $name, members: ${members.toString()}, restaurants: ${restaurants.toString()}";
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

  Group copyWith(
      {String? id,
      String? name,
      List<String>? members,
      List<Restaurant?>? restaurants}) {
    return Group(
        id: id ?? this.id,
        name: name ?? this.name,
        members: members ?? this.members,
        restaurants: restaurants ?? this.restaurants);
  }
}
