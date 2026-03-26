import 'package:flutter_test/flutter_test.dart';

import 'package:canva_clone/main.dart';

void main() {
  testWidgets('App renders Clean Start', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our app says 'Clean Start'.
    expect(find.text('Clean Start'), findsOneWidget);
  });
}
