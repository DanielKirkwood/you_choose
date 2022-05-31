import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant {
  final String? name;
  final int? price;
  final String? description;
  final List<String>? tags;

  Restaurant({this.name, this.price, this.description, this.tags});

  factory Restaurant.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Restaurant(
      name: data?['name'],
      price: data?['price'],
      description: data?['description'],
      tags: data?['tags'] is Iterable ? List.from(data?['tags']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (price != null) "price": price,
      if (description != null) "description": description,
      if (tags != null) "tags": tags,
    };
  }
}
