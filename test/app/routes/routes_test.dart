import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:you_choose/src/app/app.dart';
import 'package:you_choose/src/home/home.dart';
import 'package:you_choose/src/welcome/welcome.dart';

void main() {
  group('onGenerateAppViewPages', () {
    test('returns [HomePage] when authenticated', () {
      expect(
        onGenerateAppViewPages(AppStatus.authenticated, []),
        [
          isA<MaterialPage<void>>().having(
            (p) => p.child,
            'child',
            isA<HomePage>(),
          )
        ],
      );
    });

    test('returns [WelcomePage] when unauthenticated', () {
      expect(
        onGenerateAppViewPages(AppStatus.unauthenticated, []),
        [
          isA<MaterialPage<void>>().having(
            (p) => p.child,
            'child',
            isA<WelcomePage>(),
          )
        ],
      );
    });
  });
}
