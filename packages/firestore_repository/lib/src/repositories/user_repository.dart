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
  Future<UserModel> getUserByUsername({required String username}) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(username)
        .withConverter(
          fromFirestore: UserModel.fromFirestore,
          toFirestore: (UserModel user, options) => user.toFirestore(),
        )
        .get();

    return snapshot.data() ?? UserModel.empty;
  }

  /// returns a users firestore data by given email
  Future<UserModel> getUserByEmail({required String email}) async {
    final snapshot = await _firestore
        .collection('users')
        .withConverter(
          fromFirestore: UserModel.fromFirestore,
          toFirestore: (UserModel user, options) => user.toFirestore(),
        )
        .where('email', isEqualTo: email)
        .get();

    return snapshot.docs.first.data();
  }

  /// adds a users data to firestore
  Future<void> addUser({required UserModel user}) async {
    await _firestore
        .collection('users')
        .doc(user.username)
        .withConverter(
          fromFirestore: UserModel.fromFirestore,
          toFirestore: (UserModel user, option) => user.toFirestore(),
        )
        .set(user);
  }
}
