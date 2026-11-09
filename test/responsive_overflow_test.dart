import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:linguago/app/providers.dart';
import 'package:linguago/data/repositories/preferences_repository.dart';
import 'package:linguago/app/app.dart';

void main() {
  testWidgets('Screen renders correctly on small phone (360x640) without overflows', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'linguago_is_first_launch': false});
    final prefs = await PreferencesRepository.create();
    // 360x640 small phone screen dimensions
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          useFirebaseProvider.overrideWith((ref) => false),
          preferencesRepositoryProvider.overrideWith((ref) async => prefs),
        ],
        child: const LinguaGoApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify home screen loaded
    expect(find.byType(LinguaGoApp), findsOneWidget);
    // Ensure no overflow errors occurred
    expect(tester.takeException(), isNull);
  });

  testWidgets('Screen renders correctly on large phone (412x915) without overflows', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'linguago_is_first_launch': false});
    final prefs = await PreferencesRepository.create();
    // 412x915 modern large phone screen dimensions (e.g. Pixel 7 / Galaxy S23+)
    tester.view.physicalSize = const Size(412, 915);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          useFirebaseProvider.overrideWith((ref) => false),
          preferencesRepositoryProvider.overrideWith((ref) async => prefs),
        ],
        child: const LinguaGoApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(LinguaGoApp), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

