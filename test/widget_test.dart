import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linguago/app/app.dart';

void main() {
  testWidgets('Design system preview smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: LinguaGoApp(),
      ),
    );

    expect(find.text('Design System Preview'), findsOneWidget);
    expect(find.text('Tactile Push Buttons (56px)'), findsOneWidget);
  });
}
