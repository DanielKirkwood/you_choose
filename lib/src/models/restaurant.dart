// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:you_choose/src/models/models.dart';

class Restaurant extends Equatable {
  final String name;
  final int price;
  final String description;
  final List<Tag>? tags;
  final Object lastModified;

  Restaurant(
      {required this.name,
        required this.price,
        required this.description,
      this.tags,
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
        lastModified: data?['lastModified']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "price": price,
      "description": description,
      "lastModified": lastModified
    };
  }

  @override
  List<Object?> get props => [name, price, description, tags, lastModified];

  Restaurant copyWith({
    String? name,
    int? price,
    String? description,
    List<Tag>? tags,
  }) {
    return Restaurant(
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      tags: tags ?? this.tags,
    );
  }
}
