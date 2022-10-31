import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// {@template restaurant}
/// Restaurant model
///
/// {@endtemplate}
@immutable
class Restaurant extends Equatable {
  /// {@macro restaurant}
  const Restaurant({
    required this.name,
    required this.price,
    required this.description,
    this.tags,
    this.docID,
  }) : assert(
          price >= 1 && price <= 4,
          'price must be between 1 and 4 inclusive.',
        );

  /// Function that creates a [Restaurant] object from JSON.
  factory Restaurant.fromJson(
    String id,
    Map<String, dynamic>? data,
  ) {
    return Restaurant(
      name: data?['name'] as String,
      price: data?['price'] as int,
      description: data?['description'] as String,
      tags:
          data?['tags'] is Iterable ? List.from(data?['tags'] as Iterable) : [],
      docID: id,
    );
  }

  /// Method for converting Restaurant to json to enable easy storing in
  /// firestore
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'tags': tags,
    };
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

  /// A list of user created tags that categorise the restaurant.
  ///
  /// Example: McDonald's could have 'cheap', 'fast food' and 'casual' as
  /// it's tags.
  final List<String>? tags;

  /// The document ID of the restaurant in firestore.
  final String? docID;

  /// Utility function which provides a method of altering fields
  /// from a current restaurant.
  Restaurant copyWith({
    String? name,
    int? price,
    String? description,
    List<String>? tags,
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
