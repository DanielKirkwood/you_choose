import 'package:cloud_firestore/cloud_firestore.dart';

/// {@template friend_repository}
/// Flutter package which manages the friend domain.
/// {@endtemplate}
class FriendRepository {
  /// {@macro friend_repository}
  FriendRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  /// Sends a friend request given the current users username
  /// and the friends username.
  Future<void> sendFriendRequest({
    required String friendUsername,
    required String currentUserUsername,
  }) async {
    final friendDocRef = _firestore.collection('users').doc(friendUsername);

    await friendDocRef
        .update({'friends.$currentUserUsername': 'incomingRequest'});

    final currentUserDocRef =
        _firestore.collection('users').doc(currentUserUsername);

    await currentUserDocRef.update({'friends.$friendUsername': 'requested'});
  }

  /// Accepts a friend requested by updating both the given currentUserUsername
  /// and the friendUsername's friend status to 'friends'
  Future<void> acceptFriendRequest({
    required String friendUsername,
    required String currentUserUsername,
  }) async {
    final friendDocRef = _firestore.collection('users').doc(friendUsername);

    await friendDocRef.update({'friends.$currentUserUsername': 'friend'});

    final currentUserDocRef =
        _firestore.collection('users').doc(currentUserUsername);

    await currentUserDocRef.update({'friends.$friendUsername': 'friend'});
  }

  /// removes by deleting the fieldValues in both the current
  /// user and the requested friends documents
  Future<void> removeFriend({
    required String friendUsername,
    required String currentUserUsername,
  }) async {
    final friendDocRef = _firestore.collection('users').doc(friendUsername);

    await friendDocRef
        .update({'friends.$currentUserUsername': FieldValue.delete()});

    final currentUserDocRef =
        _firestore.collection('users').doc(currentUserUsername);

    await currentUserDocRef
        .update({'friends.$friendUsername': FieldValue.delete()});
  }
}
