import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_repository/firestore_repository.dart';

/// {@template group_repository}
/// Flutter package which manages the group domain.
/// {@endtemplate}
class GroupRepository {
  /// {@macro group_repository}
  GroupRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  /// Retrieves all the [Group]s which the given user is a member of.
  Future<List<Group>> getGroups({required String username}) async {
    final groups = <Group>[];

    final groupsQuery = _firestore
        .collection('groups')
        .withConverter(
          fromFirestore: Group.fromFirestore,
          toFirestore: (Group group, options) => group.toFirestore(),
        )
        .where('members', arrayContains: username);

    final groupsSnapshot = await groupsQuery.get();

    for (var i = 0; i < groupsSnapshot.size; i++) {
      final group = groupsSnapshot.docs[i].data();
      groups.add(group);
    }

    return groups;
  }

  /// Adds a [Group] to firestore.
  Future<Group> addGroup({required Group group}) async {
    final groupDocRef = _firestore
        .collection('groups')
        .withConverter(
          fromFirestore: Group.fromFirestore,
          toFirestore: (Group group, options) => group.toFirestore(),
        )
        .doc();

    final addedGroup = group.copyWith(docID: groupDocRef.id);
    await groupDocRef.set(addedGroup);

    return addedGroup;
  }

  /// Adds a [Tag] to a group given a Tag object and group id.
  Future<Tag> addGroupTag({required Tag tag, required String groupID}) async {
    final tagDocRef = _firestore
        .collection('groups')
        .doc(groupID)
        .collection('tags')
        .withConverter(
          fromFirestore: Tag.fromFirestore,
          toFirestore: (Tag tag, options) => tag.toFirestore(),
        )
        .doc();

    final updatedTag = tag.copyWith(id: tagDocRef.id);
    await tagDocRef.set(updatedTag);

    return updatedTag;
  }
}
