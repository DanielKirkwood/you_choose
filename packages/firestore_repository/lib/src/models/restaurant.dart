import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firestore_repository/src/models/tag.dart';

/// {@template restaurant}
/// Restaurant model
///
/// {@endtemplate}
class Restaurant extends Equatable {
  /// {@macro restaurant}
  const Restaurant({
    required this.name,
    required this.price,
    required this.description,
    this.tags,
    this.docID,
  });

  /// Function that creates a [Restaurant] object from a firestore document.
  factory Restaurant.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      // ignore: avoid_unused_constructor_parameters
      SnapshotOptions? options) {
    final data = snapshot.data();
    return Restaurant(
      name: data?['name'] as String,
      price: data?['price'] as int,
      description: data?['description'] as String,
      docID: snapshot.id,
    );
  }

  /// The restaurants name.
  final String name;

  /// The average price of the restaurant as represented as integer where:
  ///
  /// 1 = Inexpensive
  ///
  /// 2 = Moderately expensive
  ///
  /// 3 = Expensive
  ///
  /// 4 = Very Expensive
  final int price;

  /// A short description of the restaurant.
  final String description;

  /// A list of user created [Tag]s that categorise the restaurant.
  ///
  /// Example: McDonald's could have 'cheap', 'fast food' and 'casual' as
  /// it's tags.
  final List<Tag>? tags;

  /// The document ID of the restaurant in firestore.
  final String? docID;

  /// Method for converting Restaurant to json to enable easy storing in
  /// firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'price': price,
      'description': description,
    };
  }

  /// Utility function which provides a method of altering fields
  /// from a current restaurant.
  Restaurant copyWith({
    String? name,
    int? price,
    String? description,
    List<Tag>? tags,
    String? docID,
  }) {
    return Restaurant(
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      docID: docID ?? this.docID,
    );
  }

  @override
  List<Object?> get props => [name, price, description, tags, docID];

  @override
  bool get stringify => true;
}
