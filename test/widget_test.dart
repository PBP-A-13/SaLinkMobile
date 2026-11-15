import 'package:flutter_test/flutter_test.dart';
import 'package:salink_mobile/main.dart';

void main() {
  testWidgets('SaLink Mobile smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify app bar title
    expect(find.text('SaLink Mobile'), findsOneWidget);

    // Verify main welcome banner
    expect(find.text('Selamat Datang di SaLink! 👋'), findsOneWidget);
  });
}
