import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_repository/firestore_repository.dart';

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

    final restaurantsCollection =
        groupDocument.collection('restaurants').withConverter(
              fromFirestore: Restaurant.fromFirestore,
              toFirestore: (Restaurant restaurant, options) =>
                  restaurant.toFirestore(),
            );

    final restaurantQuery = await restaurantsCollection.get();

    for (var i = 0; i < restaurantQuery.size; i++) {
      final doc = restaurantQuery.docs[i];
      var restaurant = doc.data();

      final tags = <Tag>[];

      final tagsCollection = groupDocument
          .collection('restaurants')
          .doc(restaurant.docID)
          .collection('tags')
          .withConverter(
            fromFirestore: Tag.fromFirestore,
            toFirestore: (Tag tag, options) => tag.toFirestore(),
          );

      final tagQuery = await tagsCollection.get();

      for (var i = 0; i < tagQuery.size; i++) {
        tags.add(tagQuery.docs[i].data());
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
      final restaurantsCollection = _firestore
          .collection('groups')
          .doc(group.docID)
          .collection('restaurants')
          .withConverter(
            fromFirestore: Restaurant.fromFirestore,
            toFirestore: (Restaurant restaurant, options) =>
                restaurant.toFirestore(),
          );

      await restaurantsCollection.add(restaurant).then((doc) {
        if (restaurant.tags != null) {
          final tagsCollection = doc.collection('tags').withConverter(
                fromFirestore: Tag.fromFirestore,
                toFirestore: (Tag tag, options) => tag.toFirestore(),
              );

          for (final tag in restaurant.tags!) {
            tagsCollection.add(tag);
          }
        }
      });
    }
  }
}
