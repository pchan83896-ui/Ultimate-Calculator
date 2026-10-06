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
  return find.widgetWithText(FilledButton, text).first;
}

String displayValue(WidgetTester tester) {
  final widget = tester.widget<Text>(display());
  return widget.data ?? '';
}

void main() {
  testWidgets('can calculate 2 + 3 = 5', (tester) async {
    await tester.pumpWidget(UltimateCalculatorApp(key: UniqueKey()));

    await tester.tap(button('2'));
    await tester.tap(button('+'));
    await tester.tap(button('3'));
    await tester.tap(button('='));

    await tester.pump();

    expect(display(), findsOneWidget);
    expect(displayValue(tester), '5');
  });

  testWidgets('respects operator precedence: 2 + 3 × 4 = 14', (tester) async {
    await tester.pumpWidget(UltimateCalculatorApp(key: UniqueKey()));

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
    await tester.pumpWidget(UltimateCalculatorApp(key: UniqueKey()));

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
    await tester.pumpWidget(UltimateCalculatorApp(key: UniqueKey()));

    await tester.tap(button('7'));
    await tester.tap(button('−'));
    await tester.tap(button('9'));
    await tester.tap(button('='));

    await tester.pump();

    expect(display(), findsOneWidget);
    expect(displayValue(tester), '-2');
  });

  testWidgets('AC clears the calculator', (tester) async {
    await tester.pumpWidget(UltimateCalculatorApp(key: UniqueKey()));

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
    await tester.pumpWidget(UltimateCalculatorApp(key: UniqueKey()));

    await tester.tap(button('1'));
    await tester.tap(button('2'));
    await tester.tap(button('3'));

    await tester.tap(button('⌫'));
    await tester.pump();

    expect(display(), findsOneWidget);
    expect(displayValue(tester), '12');
  });

  testWidgets('± toggles a positive number to negative', (tester) async {
    await tester.pumpWidget(UltimateCalculatorApp(key: UniqueKey()));

    await tester.tap(button('5'));
    await tester.tap(button('±'));
    await tester.pump();

    expect(display(), findsOneWidget);
    expect(displayValue(tester), '-5');
  });

  testWidgets('± toggles a negative number to positive', (tester) async {
    await tester.pumpWidget(UltimateCalculatorApp(key: UniqueKey()));

    await tester.tap(button('5'));
    await tester.tap(button('±'));
    await tester.tap(button('±'));
    await tester.pump();

    expect(display(), findsOneWidget);
    expect(displayValue(tester), '5');
  });

  testWidgets('± toggles the last number in an expression', (tester) async {
    await tester.pumpWidget(UltimateCalculatorApp(key: UniqueKey()));

    await tester.tap(button('2'));
    await tester.tap(button('+'));
    await tester.tap(button('5'));
    await tester.tap(button('±'));
    await tester.pump();

    expect(display(), findsOneWidget);
    expect(displayValue(tester), '-3');
  });


  testWidgets('can calculate expressions with parentheses', (tester) async {
    await tester.pumpWidget(UltimateCalculatorApp(key: UniqueKey()));

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
    await tester.pumpWidget(UltimateCalculatorApp(key: UniqueKey()));

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
    await tester.pumpWidget(UltimateCalculatorApp(key: UniqueKey()));

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
    await tester.pumpWidget(UltimateCalculatorApp(key: UniqueKey()));

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


  testWidgets('pi calculates correctly', (tester) async {
    await tester.pumpWidget(UltimateCalculatorApp(key: UniqueKey()));
    await tester.pump();


    await tester.tap(button('π'));
    await tester.pump();


    await tester.tap(button('='));
    await tester.pump();


    expect(
      double.parse(displayValue(tester)),
      closeTo(3.1415926535, 0.000001),
    );
  });

  testWidgets('2 × pi calculates correctly', (tester) async {
    await tester.pumpWidget(UltimateCalculatorApp(key: UniqueKey()));
    await tester.pump();



    await tester.tap(button('2'));
    await tester.pump();

    await tester.tap(button('×'));
    await tester.pump();

    await tester.tap(button('π'));
    await tester.tap(button('='));
    await tester.pump();

    expect(
      double.parse(displayValue(tester)),
      closeTo(6.283185307, 0.000001),
    );
  });

  testWidgets('pi squared calculates correctly', (tester) async {
    await tester.pumpWidget(UltimateCalculatorApp(key: UniqueKey()));
    await tester.pump();



    await tester.tap(button('π'));
    await tester.pump();

    await tester.tap(button('^'));
    await tester.pump();

    await tester.tap(button('2'));
    await tester.pump();

    await tester.tap(button('='));
    await tester.pump();

    expect(
      double.parse(displayValue(tester)),
      closeTo(9.869604401, 0.000001),
    );
  });


  testWidgets('e calculates correctly', (tester) async {
    await tester.pumpWidget(UltimateCalculatorApp(key: UniqueKey()));

    await tester.tap(button('e'));
    await tester.pump();

    await tester.tap(button('='));
    await tester.pump();

    expect(
      double.parse(displayValue(tester)),
      closeTo(2.7182818284, 0.000001),
    );
  });

  testWidgets('2 × e calculates correctly', (tester) async {
    await tester.pumpWidget(UltimateCalculatorApp(key: UniqueKey()));

    await tester.tap(button('2'));
    await tester.pump();

    await tester.tap(button('×'));
    await tester.pump();

    await tester.tap(button('e'));
    await tester.pump();

    await tester.tap(button('='));
    await tester.pump();

    expect(
      double.parse(displayValue(tester)),
      closeTo(5.4365636568, 0.000001),
    );
  });

  testWidgets('e squared calculates correctly', (tester) async {
    await tester.pumpWidget(UltimateCalculatorApp(key: UniqueKey()));

    await tester.tap(button('e'));
    await tester.pump();

    await tester.tap(button('^'));
    await tester.pump();

    await tester.tap(button('2'));
    await tester.pump();

    await tester.tap(button('='));
    await tester.pump();

    expect(
      double.parse(displayValue(tester)),
      closeTo(7.3890560989, 0.000001),
    );
  });


  testWidgets('2 to the power of 3 calculates correctly', (tester) async {
    await tester.pumpWidget(UltimateCalculatorApp(key: UniqueKey()));

    await tester.tap(button('2'));
    await tester.pump();

    await tester.tap(button('^'));
    await tester.pump();

    await tester.tap(button('3'));
    await tester.pump();

    await tester.tap(button('='));
    await tester.pump();

    expect(
      double.parse(displayValue(tester)),
      closeTo(8, 0.000001),
    );
  });

  testWidgets('5 to the power of 2 calculates correctly', (tester) async {
    await tester.pumpWidget(UltimateCalculatorApp(key: UniqueKey()));

    await tester.tap(button('5'));
    await tester.pump();

    await tester.tap(button('^'));
    await tester.pump();

    await tester.tap(button('2'));
    await tester.pump();

    await tester.tap(button('='));
    await tester.pump();

    expect(
      double.parse(displayValue(tester)),
      closeTo(25, 0.000001),
    );
  });

  testWidgets('power operator is right associative', (tester) async {
    await tester.pumpWidget(UltimateCalculatorApp(key: UniqueKey()));

    await tester.tap(button('2'));
    await tester.pump();

    await tester.tap(button('^'));
    await tester.pump();

    await tester.tap(button('3'));
    await tester.pump();

    await tester.tap(button('^'));
    await tester.pump();

    await tester.tap(button('2'));
    await tester.pump();

    await tester.tap(button('='));
    await tester.pump();

    expect(
      double.parse(displayValue(tester)),
      closeTo(512, 0.000001),
    );
  });

}
