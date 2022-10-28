import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// {@template tag}
/// Tag model
///
/// {@endtemplate}
@immutable
class Tag extends Equatable {
  /// {@macro tag}
  const Tag({
    required this.name,
    this.id,
  });

  /// Function that creates a [Tag] object from JSON.
  factory Tag.fromJson(
    String id,
    Map<String, dynamic>? data,
  ) {
    return Tag(
      name: data?['name'] as String,
      id: id,
    );
  }

  /// Method for converting Restaurant to json to enable easy storing in
  /// firestore
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
    };
  }

  /// The tag name
  final String name;

  /// The document id of the tag in firestore
  final String? id;

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
