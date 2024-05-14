import 'package:espresso_challange/app.dart';
import 'package:espresso_challange/ui/screens/splash_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Pump SplashScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const SplashScreen());
    await tester.pumpAndSettle();
  });

  testWidgets('Pump App', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();
  });
}
