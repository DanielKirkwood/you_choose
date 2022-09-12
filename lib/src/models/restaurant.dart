import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Restaurant extends Equatable {
  final String name;
  final int price;
  final String description;
  final List<String> tags;
  final Object lastModified;

  Restaurant(
      {required this.name,
        required this.price,
        required this.description,
        required this.tags,
      Timestamp? lastModified})
      : lastModified = lastModified ?? FieldValue.serverTimestamp();

  @override
  String toString() {
    return "name: $name, price: $price, description: $description, tags: $tags, lastModified: $lastModified";
  }

  factory Restaurant.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Restaurant(
        name: data?['name'],
        price: data?['price'],
        description: data?['description'],
        tags: data?['tags'] is Iterable ? List.from(data?['tags']) : [],
        lastModified: data?['lastModified']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "price": price,
      "description": description,
      "tags": tags,
      "lastModified": lastModified
    };
  }

  @override
  List<Object?> get props => [name, price, description, tags, lastModified];
}
