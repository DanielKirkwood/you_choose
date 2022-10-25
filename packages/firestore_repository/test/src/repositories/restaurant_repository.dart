// ignore_for_file: subtype_of_sealed_class

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:firestore_repository/firestore_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

const _mockGroupDocumentID = 'mock-doc-id';
const _mockRestaurantName = 'mock-name';
const _mockRestaurantPrice = 1;
const _mockRestaurantDescription = 'mock-description';

const _mockRestaurant = Restaurant(
  name: _mockRestaurantName,
  price: _mockRestaurantPrice,
  description: _mockRestaurantDescription,
);

const _mockGroup = Group(name: 'mock-name', members: <String>[]);

class MockFirebaseCore extends Mock
    with MockPlatformInterfaceMixin
    implements FirebasePlatform {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock
    implements CollectionReference<Restaurant> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockRestaurantDocumentReference extends Mock
    implements DocumentReference<Restaurant> {}

class MockQuerySnapshot extends Mock implements QuerySnapshot<Restaurant> {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RestaurantRepository', () {
    late FirebaseFirestore firestore;
    late RestaurantRepository restaurantRepository;

    setUp(() {
      const options = FirebaseOptions(
        apiKey: 'apiKey',
        appId: 'appId',
        messagingSenderId: 'messagingSenderId',
        projectId: 'projectId',
      );
      final platformApp = FirebaseAppPlatform(defaultFirebaseAppName, options);
      final firebaseCore = MockFirebaseCore();

      when(() => firebaseCore.apps).thenReturn([platformApp]);
      when(firebaseCore.app).thenReturn(platformApp);
      when(
        () => firebaseCore.initializeApp(
          name: defaultFirebaseAppName,
          options: options,
        ),
      ).thenAnswer((_) async => platformApp);

      Firebase.delegatePackingProperty = firebaseCore;

      firestore = MockFirebaseFirestore();
      restaurantRepository = RestaurantRepository(firestore: firestore);
    });

    test('creates FirebaseFirestore instance internally when not injected', () {
      expect(RestaurantRepository.new, isNot(throwsException));
    });


    group('addRestaurant', () {
      setUp(() {
        when(
          () => firestore
              .collection('groups')
              .doc(_mockGroupDocumentID)
              .collection('restaurants')
              .withConverter(
                fromFirestore: Restaurant.fromFirestore,
                toFirestore: (Restaurant restaurant, options) =>
                    restaurant.toFirestore(),
              ),
        ).thenReturn(MockCollectionReference());

        when(
          () => firestore
              .collection('groups')
              .doc(_mockGroupDocumentID)
              .collection('restaurants')
              .withConverter(
                fromFirestore: Restaurant.fromFirestore,
                toFirestore: (Restaurant restaurant, options) =>
                    restaurant.toFirestore(),
              )
              .add(_mockRestaurant),
        ).thenAnswer((_) => Future.value(MockRestaurantDocumentReference()));
      });

      test('does not throw when restaurant added', () async {
        await expectLater(
          restaurantRepository.addRestaurant(
            restaurant: _mockRestaurant,
            groups: [_mockGroup],
          ),
          completes,
        );
      });
    });
  });
}
