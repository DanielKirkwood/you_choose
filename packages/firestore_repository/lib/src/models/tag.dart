import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// {@template tag}
/// Tag model
///
/// {@endtemplate}
class Tag extends Equatable {
  /// {@macro tag}
  const Tag({
    required this.name,
    this.id,
  });

  /// Function that creates a [Tag] object from a firestore document.
  factory Tag.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      // ignore: avoid_unused_constructor_parameters
      SnapshotOptions? options) {
    final data = snapshot.data();
    return Tag(
      name: data?['name'] as String,
      id: data?['id'] as String,
    );
  }

  /// The tag name
  final String name;

  /// The document id of the tag in firestore
  final String? id;

  /// Method for converting Restaurant to json to enable easy storing in
  /// firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'id': id,
    };
  }

  /// Utility function which provides a method of altering fields
  /// from a current tag.
  Tag copyWith({
    String? name,
    String? id,
  }) {
    return Tag(
      name: name ?? this.name,
      id: id ?? this.id,
    );
  }

  @override
  List<Object?> get props => [name, id];

  @override
  bool get stringify => true;
}
