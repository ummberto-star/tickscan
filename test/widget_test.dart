import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tickscan/app.dart';

void main() {
  testWidgets('App builds without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const TickScanApp());
    await tester.pump();
    // Root should contain a MaterialApp somewhere in the tree
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
