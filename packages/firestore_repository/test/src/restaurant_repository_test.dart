// ignore_for_file: subtype_of_sealed_class

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:firestore_repository/firestore_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockRestaurant extends Mock implements Restaurant {}

class MockGroup extends Mock implements Group {}

class MockFirebaseCore extends Mock
    with MockPlatformInterfaceMixin
    implements FirebasePlatform {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockQuerySnapshot extends Mock implements QuerySnapshot {}

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
        when(() => firestore.collection('groups'))
            .thenReturn(MockCollectionReference());

        when(() => firestore.collection('groups').doc(any()))
            .thenReturn(MockDocumentReference());

        when(
          () => firestore
              .collection('groups')
              .doc(any())
              .collection('restaurants'),
        ).thenReturn(MockCollectionReference());

        when(
          () => firestore
              .collection('groups')
              .doc(any())
              .collection('restaurants')
              .doc(),
        ).thenReturn(MockDocumentReference());

        when(
          () => firestore
              .collection('groups')
              .doc(any())
              .collection('restaurants')
              .doc()
              .set(any()),
        ).thenAnswer((_) => Future.value());
      });
      test('does not throw when restaurant added', () async {
        await expectLater(
          restaurantRepository.addRestaurant(
            restaurant: MockRestaurant(),
            groups: [MockGroup()],
          ),
          completes,
        );
      });
    });
  });
}