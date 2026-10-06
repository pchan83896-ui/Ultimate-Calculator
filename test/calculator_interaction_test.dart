import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ultimate_calculator/app/app.dart';

Finder display() {
  return find.byWidgetPredicate(
    (widget) =>
        widget is Text &&
        widget.style?.fontSize == 45.0,
  );
}

Finder button(String text) {
  return find.widgetWithText(FilledButton, text);
}

String displayValue(WidgetTester tester) {
  final widget = tester.widget<Text>(display());
  return widget.data ?? '';
}

void main() {
  testWidgets('can calculate 2 + 3 = 5', (tester) async {
    await tester.pumpWidget(const UltimateCalculatorApp());

    await tester.tap(button('2'));
    await tester.tap(button('+'));
    await tester.tap(button('3'));
    await tester.tap(button('='));

    await tester.pump();

    expect(display(), findsOneWidget);
    expect(displayValue(tester), '5');
  });

  testWidgets('respects operator precedence: 2 + 3 × 4 = 14', (tester) async {
    await tester.pumpWidget(const UltimateCalculatorApp());

    await tester.tap(button('2'));
    await tester.tap(button('+'));
    await tester.tap(button('3'));
    await tester.tap(button('×'));
    await tester.tap(button('4'));
    await tester.tap(button('='));

    await tester.pump();

    expect(display(), findsOneWidget);
    expect(displayValue(tester), '14');
  });

  testWidgets('can calculate division: 10 ÷ 2 = 5', (tester) async {
    await tester.pumpWidget(const UltimateCalculatorApp());

    await tester.tap(button('1'));
    await tester.tap(button('0'));
    await tester.tap(button('÷'));
    await tester.tap(button('2'));
    await tester.tap(button('='));

    await tester.pump();

    expect(display(), findsOneWidget);
    expect(displayValue(tester), '5');
  });

  testWidgets('can calculate negative result: 7 − 9 = -2', (tester) async {
    await tester.pumpWidget(const UltimateCalculatorApp());

    await tester.tap(button('7'));
    await tester.tap(button('−'));
    await tester.tap(button('9'));
    await tester.tap(button('='));

    await tester.pump();

    expect(display(), findsOneWidget);
    expect(displayValue(tester), '-2');
  });

  testWidgets('AC clears the calculator', (tester) async {
    await tester.pumpWidget(const UltimateCalculatorApp());

    await tester.tap(button('1'));
    await tester.tap(button('2'));
    await tester.tap(button('+'));
    await tester.tap(button('3'));

    await tester.tap(button('AC'));
    await tester.pump();

    expect(display(), findsOneWidget);
    expect(displayValue(tester), '0');
  });

  testWidgets('backspace removes the last digit', (tester) async {
    await tester.pumpWidget(const UltimateCalculatorApp());

    await tester.tap(button('1'));
    await tester.tap(button('2'));
    await tester.tap(button('3'));

    await tester.tap(button('⌫'));
    await tester.pump();

    expect(display(), findsOneWidget);
    expect(displayValue(tester), '12');
  });

  testWidgets('± toggles a positive number to negative', (tester) async {
    await tester.pumpWidget(const UltimateCalculatorApp());

    await tester.tap(button('5'));
    await tester.tap(button('±'));
    await tester.pump();

    expect(display(), findsOneWidget);
    expect(displayValue(tester), '-5');
  });

  testWidgets('± toggles a negative number to positive', (tester) async {
    await tester.pumpWidget(const UltimateCalculatorApp());

    await tester.tap(button('5'));
    await tester.tap(button('±'));
    await tester.tap(button('±'));
    await tester.pump();

    expect(display(), findsOneWidget);
    expect(displayValue(tester), '5');
  });

  testWidgets('± toggles the last number in an expression', (tester) async {
    await tester.pumpWidget(const UltimateCalculatorApp());

    await tester.tap(button('2'));
    await tester.tap(button('+'));
    await tester.tap(button('5'));
    await tester.tap(button('±'));
    await tester.pump();

    expect(display(), findsOneWidget);
    expect(displayValue(tester), '-3');
  });


  testWidgets('can calculate expressions with parentheses', (tester) async {
    await tester.pumpWidget(const UltimateCalculatorApp());

    await tester.tap(button('('));
    await tester.tap(button('2'));
    await tester.tap(button('+'));
    await tester.tap(button('3'));
    await tester.tap(button(')'));
    await tester.tap(button('×'));
    await tester.tap(button('4'));
    await tester.tap(button('='));
    await tester.pump();

    expect(display(), findsOneWidget);
    expect(displayValue(tester), '20');
  });

  testWidgets('respects parentheses over operator precedence', (tester) async {
    await tester.pumpWidget(const UltimateCalculatorApp());

    await tester.tap(button('2'));
    await tester.tap(button('×'));
    await tester.tap(button('('));
    await tester.tap(button('3'));
    await tester.tap(button('+'));
    await tester.tap(button('4'));
    await tester.tap(button(')'));
    await tester.tap(button('='));
    await tester.pump();

    expect(display(), findsOneWidget);
    expect(displayValue(tester), '14');
  });


  testWidgets('can calculate a square root', (tester) async {
    await tester.pumpWidget(const UltimateCalculatorApp());

    await tester.tap(button('√'));
    await tester.tap(button('9'));
    await tester.tap(button(')'));
    await tester.tap(button('='));
    await tester.pump();

    expect(display(), findsOneWidget);
    expect(displayValue(tester), '3');
  });

  testWidgets('can calculate a square root of a parenthesized expression',
      (tester) async {
    await tester.pumpWidget(const UltimateCalculatorApp());

    await tester.tap(button('√'));
    await tester.tap(button('('));
    await tester.tap(button('9'));
    await tester.tap(button('+'));
    await tester.tap(button('7'));
    await tester.tap(button(')'));
    await tester.tap(button(')'));
    await tester.tap(button('='));
    await tester.pump();

    expect(display(), findsOneWidget);
    expect(displayValue(tester), '4');
  });

}
