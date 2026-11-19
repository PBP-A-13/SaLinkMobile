
import 'package:flutter_test/flutter_test.dart';
import 'package:salink_mobile/main.dart';
import 'package:salink_mobile/screens/auth/login_page.dart';

void main() {
  testWidgets('SaLink Mobile smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Verify that LoginPage is displayed as the initial screen.
    expect(find.byType(LoginPage), findsOneWidget);
  });
}
