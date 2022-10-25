import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_repository/firestore_repository.dart';

/// {@template user_repository}
/// Flutter package which manages the user domain.
/// {@endtemplate}
class UserRepository {
  /// {@macro user_repository}
  UserRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  /// returns a users firestore data by given username
  Future<User> getUserByUsername({required String username}) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(username)
        .withConverter(
          fromFirestore: User.fromFirestore,
          toFirestore: (User user, options) => user.toFirestore(),
        )
        .get();

    return snapshot.data() ?? User.empty;
  }

  /// returns a users firestore data by given email
  Future<User> getUserByEmail({required String email}) async {
    final snapshot = await _firestore
        .collection('users')
        .withConverter(
          fromFirestore: User.fromFirestore,
          toFirestore: (User user, options) => user.toFirestore(),
        )
        .where('email', isEqualTo: email)
        .get();

    return snapshot.docs.first.data();
  }

  /// adds a users data to firestore
  Future<void> addUser({required User user}) async {
    await _firestore
        .collection('users')
        .doc(user.username)
        .withConverter(
          fromFirestore: User.fromFirestore,
          toFirestore: (User user, option) => user.toFirestore(),
        )
        .set(user);
  }
}
