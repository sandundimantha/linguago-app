import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linguago/app/app.dart';

void main() {
  testWidgets('App shell and bottom navigation smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: LinguaGoApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify 4 bottom navigation tab icons are present
    expect(find.byIcon(Icons.home_rounded), findsOneWidget);
    expect(find.byIcon(Icons.fitness_center_rounded), findsOneWidget);
    expect(find.byIcon(Icons.trending_up_rounded), findsOneWidget);
    expect(find.byIcon(Icons.account_circle_rounded), findsOneWidget);

    // Initial screen is Home
    expect(find.text('Good morning, Alex!'), findsOneWidget);

    // Switch to Practice tab by icon
    await tester.tap(find.byIcon(Icons.fitness_center_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Practice Hub'), findsOneWidget);

    // Switch to Progress tab by icon
    await tester.tap(find.byIcon(Icons.trending_up_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Learning Analytics'), findsOneWidget);

    // Switch to Profile tab by icon
    await tester.tap(find.byIcon(Icons.account_circle_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Alex'), findsOneWidget);

    // Switch back to Home tab by icon
    await tester.tap(find.byIcon(Icons.home_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Good morning, Alex!'), findsOneWidget);

    // Launch full-screen lesson (without bottom navigation bar)
    await tester.tap(find.text('Continue Lesson'));
    await tester.pumpAndSettle();

    // In Lesson screen: exercise prompt is visible and bottom nav icons are NOT in tree
    expect(find.text('Select the polite way to order coffee:'), findsOneWidget);
    expect(find.byIcon(Icons.fitness_center_rounded), findsNothing);

    // Close lesson screen
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();

    // Returned to Home tab with navigation bar restored
    expect(find.text('Good morning, Alex!'), findsOneWidget);
    expect(find.byIcon(Icons.home_rounded), findsOneWidget);
  });
}
