import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Tag extends Equatable {
  final String name;
  final String? id;

  const Tag({
    required this.name,
    this.id,
  });

  Tag copyWith({
    String? name,
    String? id,
  }) {
    return Tag(
      name: name ?? this.name,
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
      id: data?['id'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "id": id,
    };
  }

  @override
  String toString() => 'Tag(name: $name, id: $id)';

  @override
  List<Object?> get props => [name, id];
}
