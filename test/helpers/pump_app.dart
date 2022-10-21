import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:you_choose/src/repositories/repositories.dart';

class MockFirebaseAuthRepository extends Mock
    implements FirebaseAuthRepository {}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    FirebaseAuthRepository? firebaseAuthRepository,
  }) {
    return pumpWidget(
      RepositoryProvider.value(
        value: firebaseAuthRepository ?? MockFirebaseAuthRepository(),
        child: MaterialApp(
          home: Scaffold(body: widget),
        ),
      ),
    );
  }

  Future<void> pumpRoute(
    Route<dynamic> route, {
    FirebaseAuthRepository? firebaseAuthRepository,
  }) {
    return pumpApp(
      Navigator(onGenerateRoute: (_) => route),
      firebaseAuthRepository: firebaseAuthRepository,
    );
  }
}
