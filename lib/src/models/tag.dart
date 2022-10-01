import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Tag extends Equatable {
  final String name;
  final String color;
  final String? id;

  const Tag({
    required this.name,
    required this.color,
    this.id,
  });

  Tag copyWith({
    String? name,
    String? color,
    String? id,
  }) {
    return Tag(
      name: name ?? this.name,
      color: color ?? this.color,
      id: id ?? this.id,
    );
  }

  factory Tag.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Tag(
      name: data?['name'],
      color: data?['color'],
      id: data?['id'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "color": color,
      "id": id,
    };
  }

  @override
  String toString() => 'Tag(name: $name, color: $color, id: $id)';

  @override
  List<Object?> get props => [name, color, id];
}
