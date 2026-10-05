import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ultimate_calculator/app/app.dart';

void main() {
  testWidgets('Ultimate Calculator page loads', (tester) async {
    await tester.pumpWidget(const UltimateCalculatorApp());

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);

    expect(find.text('Ultimate Calculator'), findsOneWidget);

    expect(find.text('AC'), findsOneWidget);
    expect(find.text('⌫'), findsOneWidget);
    expect(find.text('%'), findsOneWidget);
    expect(find.text('÷'), findsOneWidget);
    expect(find.text('×'), findsOneWidget);
    expect(find.text('−'), findsOneWidget);
    expect(find.text('+'), findsOneWidget);
    expect(find.text('='), findsOneWidget);
  });
}
