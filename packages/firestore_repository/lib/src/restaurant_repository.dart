import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:models/models.dart';

/// {@template restaurant_repository}
/// Flutter package which manages the restaurant domain.
/// {@endtemplate}
class RestaurantRepository {
  /// {@macro restaurant_repository}
  RestaurantRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  /// Retrieves all the restaurants from a group collection given a groupID.
  Future<List<Restaurant>> getRestaurantData({required String groupID}) async {
    final restaurants = <Restaurant>[];

    final groupDocument = _firestore.collection('groups').doc(groupID);

    final restaurantsCollection = groupDocument.collection('restaurants');

    final restaurantQuery = await restaurantsCollection.get();

    for (var i = 0; i < restaurantQuery.size; i++) {
      final docRef = restaurantQuery.docs[i];
      var restaurant = Restaurant.fromJson(docRef.id, docRef.data());

      final tags = <Tag>[];

      final tagsCollection = groupDocument
          .collection('restaurants')
          .doc(restaurant.docID)
          .collection('tags');

      final tagQuery = await tagsCollection.get();

      for (var i = 0; i < tagQuery.size; i++) {
        final docRef = tagQuery.docs[i];
        final tag = Tag.fromJson(docRef.id, docRef.data());
        tags.add(tag);
      }

      restaurant = restaurant.copyWith(tags: tags);
      restaurants.add(restaurant);
    }

    return restaurants;
  }

  /// Adds a restaurant to firestore including the tag sub-collection
  /// if tags exist in object.
  Future<void> addRestaurant({
    required Restaurant restaurant,
    required List<Group> groups,
  }) async {
    for (final group in groups) {
      final groupDocRef = _firestore.collection('groups').doc(group.docID);

      final restaurantDocRef = groupDocRef.collection('restaurants').doc();
      await restaurantDocRef.set(restaurant.toJson());

      if (restaurant.tags != null) {
        final tagsCollection = restaurantDocRef.collection('tags');
        for (final tag in restaurant.tags!) {
          await tagsCollection.add(tag.toJson());
        }
      }
    }
  }
}
