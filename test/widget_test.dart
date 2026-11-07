import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linguago/app/app.dart';

void main() {
  testWidgets('Home Dashboard full screen and navigation smoke test', (WidgetTester tester) async {
    // Set 360x800 surface size to specifically test small phone responsiveness
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const ProviderScope(
        child: LinguaGoApp(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Top bar items
    expect(find.byIcon(Icons.local_fire_department_rounded), findsWidgets);
    expect(find.byIcon(Icons.diamond_rounded), findsOneWidget);

    // 2. Greeting section
    expect(find.text('Good morning, Alex!'), findsOneWidget);
    expect(find.text('Keep your momentum going today.'), findsOneWidget);

    // 3. 3-Stat cards strip
    expect(find.text('STREAK'), findsOneWidget);
    expect(find.text('18 Days'), findsOneWidget);
    expect(find.text('TOTAL XP'), findsOneWidget);
    expect(find.text('1,450'), findsOneWidget);
    expect(find.text('HEARTS'), findsOneWidget);

    // 4. Daily Goal Card
    expect(find.text('DAILY GOAL'), findsOneWidget);
    expect(find.text('80%'), findsOneWidget);
    expect(find.text('2 mins left today!'), findsOneWidget);

    // 5. Continue Lesson Hero Card
    expect(find.text('Lesson 4: Ordering at a Café'), findsOneWidget);
    expect(find.text('Continue Lesson'), findsOneWidget);

    // 6. Quick Practice Grid
    expect(find.text('Quick Practice'), findsOneWidget);
    expect(find.text('Vocabulary'), findsOneWidget);
    expect(find.text('Grammar Drill'), findsOneWidget);
    expect(find.text('Speaking Lab'), findsOneWidget);
    expect(find.text('Listening'), findsOneWidget);

    // Scroll to reveal remaining sections
    await tester.drag(find.text('Good morning, Alex!'), const Offset(0, -500));
    await tester.pumpAndSettle();

    // 7. Word of the Day Card
    expect(find.text('WORD OF THE DAY'), findsOneWidget);
    expect(find.text('Serendipity'), findsOneWidget);
    expect(find.text('Practice in sentence'), findsOneWidget);

    // 8. Mascot Cheer Banner
    expect(find.text('Lingo is cheering! 🦉'), findsOneWidget);
    expect(find.text('1 lesson left to join Diamond League top 10!'), findsOneWidget);

    // 9. Full-screen Lesson Navigation (opens without bottom bar)
    final practiceSentenceBtn = find.text('Practice in sentence');
    await tester.ensureVisible(practiceSentenceBtn);
    await tester.pumpAndSettle();
    await tester.tap(practiceSentenceBtn);
    await tester.pumpAndSettle();

    // Practice page should be reached
    expect(find.text('Practice Hub'), findsOneWidget);
  });
}
