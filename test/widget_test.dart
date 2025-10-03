// This is a basic test file for the blood sugar tracker app.

import 'package:flutter_test/flutter_test.dart';
import 'package:blood_sugar_tracker/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Pump and settle to allow all async operations to complete.
    await tester.pumpAndSettle();

    // Verify that the app builds without crashing and shows the title.
    expect(find.text('ثبت قند خون'), findsOneWidget);

    // Verify navigation tabs are present.
    expect(find.text('ثبت'), findsOneWidget);
    expect(find.text('نمودار'), findsOneWidget);
  });
}
