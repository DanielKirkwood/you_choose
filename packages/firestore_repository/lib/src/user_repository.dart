import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:models/models.dart';

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
    final doc = await _firestore.collection('users').doc(username).get();

    if (!doc.exists) return UserModel.empty;

    return UserModel.fromJson(doc.id, doc.data());
  }

  /// returns a users firestore data by given email
  Future<UserModel> getUserByEmail({required String email}) async {
    final snapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (snapshot.size != 1) return UserModel.empty;

    final docRef = snapshot.docs.first;
    return UserModel.fromJson(docRef.id, docRef.data());
  }

  /// adds a users data to firestore
  Future<void> addUser({required UserModel user}) async {
    await _firestore.collection('users').doc(user.username).set(user.toJson());
  }
}
