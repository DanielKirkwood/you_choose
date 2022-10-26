// ignore_for_file: must_be_immutable
import 'package:authentication_repository/authentication_repository.dart';
import 'package:cache/cache.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:firestore_repository/firestore_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

const _mockFirebaseUsername = 'mock-username';
const _mockFirebaseUserEmail = 'mock-email';

class MockCacheClient extends Mock implements CacheClient {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseCore extends Mock
    with MockPlatformInterfaceMixin
    implements FirebasePlatform {}

class MockFirebaseUser extends Mock implements User {}

class MockUserCredential extends Mock implements UserCredential {}

class FakeAuthCredential extends Fake implements AuthCredential {}

class FakeAuthProvider extends Fake implements AuthProvider {}

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const email = 'test@gmail.com';
  const password = 't0ps3cret42';
  const user = UserModel(
    username: _mockFirebaseUsername,
    email: _mockFirebaseUserEmail,
    isVerified: false,
    friends: {},
  );

  group('AuthenticationRepository', () {
    late CacheClient cache;
    late FirebaseAuth firebaseAuth;
    late AuthenticationRepository authenticationRepository;
    late UserRepository userRepository;

    setUpAll(() {
      registerFallbackValue(FakeAuthCredential());
      registerFallbackValue(FakeAuthProvider());
    });

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

      cache = MockCacheClient();
      firebaseAuth = MockFirebaseAuth();
      userRepository = MockUserRepository();
      authenticationRepository = AuthenticationRepository(
        cache: cache,
        firebaseAuth: firebaseAuth,
        userRepository: userRepository,
      );
    });

    test('creates FirebaseAuth instance internally when not injected', () {
      expect(AuthenticationRepository.new, isNot(throwsException));
    });

    group('signUp', () {
      setUp(() {
        when(
          () => firebaseAuth.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) => Future.value(MockUserCredential()));
      });

      test('calls createUserWithEmailAndPassword', () async {
        await authenticationRepository.signUp(email: email, password: password);
        verify(
          () => firebaseAuth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          ),
        ).called(1);
      });

      test('succeeds when createUserWithEmailAndPassword succeeds', () async {
        expect(
          authenticationRepository.signUp(email: email, password: password),
          completes,
        );
      });

      test(
          'throws SignUpWithEmailAndPasswordFailure '
          'when createUserWithEmailAndPassword throws', () async {
        when(
          () => firebaseAuth.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(Exception());
        expect(
          authenticationRepository.signUp(email: email, password: password),
          throwsA(isA<SignUpWithEmailAndPasswordFailure>()),
        );
      });
    });

    group('logInWithEmailAndPassword', () {
      setUp(() {
        when(
          () => firebaseAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) => Future.value(MockUserCredential()));
      });

      test('calls signInWithEmailAndPassword', () async {
        await authenticationRepository.logInWithEmailAndPassword(
          email: email,
          password: password,
        );
        verify(
          () => firebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          ),
        ).called(1);
      });

      test('succeeds when signInWithEmailAndPassword succeeds', () async {
        expect(
          authenticationRepository.logInWithEmailAndPassword(
            email: email,
            password: password,
          ),
          completes,
        );
      });

      test(
          'throws LogInWithEmailAndPasswordFailure '
          'when signInWithEmailAndPassword throws', () async {
        when(
          () => firebaseAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(Exception());
        expect(
          authenticationRepository.logInWithEmailAndPassword(
            email: email,
            password: password,
          ),
          throwsA(isA<LogInWithEmailAndPasswordFailure>()),
        );
      });
    });

    group('logOut', () {
      test('calls signOut', () async {
        when(() => firebaseAuth.signOut()).thenAnswer((_) async {});
        await authenticationRepository.logOut();
        verify(() => firebaseAuth.signOut()).called(1);
      });

      test('throws LogOutFailure when signOut throws', () async {
        when(() => firebaseAuth.signOut()).thenThrow(Exception());
        expect(
          authenticationRepository.logOut(),
          throwsA(isA<LogOutFailure>()),
        );
      });
    });

    group('user', () {
      test('emits User.empty when firebase user is null', () async {
        when(() => firebaseAuth.authStateChanges())
            .thenAnswer((_) => Stream.value(null));
        await expectLater(
          authenticationRepository.user,
          emitsInOrder(const <UserModel>[UserModel.empty]),
        );
      });

      test('emits User when firebase user is not null', () async {
        final firebaseUser = MockFirebaseUser();
        const user = UserModel(
          username: _mockFirebaseUsername,
          email: _mockFirebaseUserEmail,
          isVerified: false,
          friends: {},
        );

        when(() => firebaseAuth.authStateChanges())
            .thenAnswer((_) => Stream.value(firebaseUser));

        when(() => userRepository.getUserByEmail(email: _mockFirebaseUserEmail))
            .thenAnswer((_) => Future.value(user));

        when(() => firebaseUser.email).thenReturn(_mockFirebaseUserEmail);

        await expectLater(
          authenticationRepository.user,
          emitsInOrder(const <UserModel>[user]),
        );

        verify(
          () => cache.write(
            key: AuthenticationRepository.userCacheKey,
            value: user,
          ),
        ).called(1);
      });
    });

    group('currentUser', () {
      test('returns User.empty when cached user is null', () {
        when(
          () => cache.read(key: AuthenticationRepository.userCacheKey),
        ).thenReturn(null);
        expect(
          authenticationRepository.currentUser,
          equals(UserModel.empty),
        );
      });

      test('returns User when cached user is not null', () async {
        when(
          () => cache.read<UserModel>(
            key: AuthenticationRepository.userCacheKey,
          ),
        ).thenReturn(user);
        expect(authenticationRepository.currentUser, equals(user));
      });
    });
  });
}
