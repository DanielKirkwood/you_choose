import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:you_choose/src/app/app.dart';
import 'package:you_choose/src/data/data.dart';
import 'package:you_choose/src/home/home.dart';
import 'package:you_choose/src/repositories/repositories.dart';
import 'package:you_choose/src/welcome/welcome.dart';

class MockUser extends Mock implements UserModel {}

class MockAuthenticationRepository extends Mock
    implements FirebaseAuthRepository {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

void main() {

  group('App', () {
    late FirebaseAuthRepository authenticationRepository;
    late UserModel user;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      user = MockUser();

      when(() => authenticationRepository.user).thenAnswer(
        (_) => const Stream.empty(),
      );
      when(() => authenticationRepository.currentUser).thenReturn(user);
      when(() => user.isNotEmpty).thenReturn(true);
      when(() => user.isEmpty).thenReturn(false);
      when(() => user.uid).thenReturn('uid1234567');
      when(() => user.email).thenReturn('test@gmail.com');
      when(() => user.username).thenReturn('testUser');
    });

    testWidgets('renders AppView', (tester) async {
      await tester.pumpWidget(
        MyApp(authenticationRepository: authenticationRepository),
      );
      await tester.pump();
      expect(find.byType(AppView), findsOneWidget);
    });
  });

  group('AppView', () {
    late FirebaseAuthRepository authenticationRepository;
    late AppBloc appBloc;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      appBloc = MockAppBloc();
    });

    testWidgets('navigates to WelcomePage when unauthenticated',
        (tester) async {
      when(() => appBloc.state).thenReturn(const AppState.unauthenticated());
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: authenticationRepository,
          child: MaterialApp(
            home: BlocProvider.value(value: appBloc, child: const AppView()),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(WelcomePage), findsOneWidget);
    });

    testWidgets('navigates to HomePage when authenticated', (tester) async {
      final user = MockUser();

      when(() => user.uid).thenReturn('uid1234567');
      when(() => user.email).thenReturn('test@gmail.com');
      when(() => user.username).thenReturn('testUser');

      when(() => appBloc.state).thenReturn(AppState.authenticated(user));

      await tester.pumpWidget(
        RepositoryProvider.value(
          value: authenticationRepository,
          child: MaterialApp(
            home: BlocProvider.value(value: appBloc, child: const AppView()),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
