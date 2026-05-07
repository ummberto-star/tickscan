import 'package:flutter_test/flutter_test.dart';
import 'package:tickscan/app.dart';

void main() {
  testWidgets('App launches correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const TickScanApp());
    expect(find.text('TickScan — KROK 1 ✅'), findsOneWidget);
  });
}
