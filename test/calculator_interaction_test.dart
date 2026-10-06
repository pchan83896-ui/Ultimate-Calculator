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


  testWidgets('50 percent calculates correctly', (tester) async {
    await tester.pumpWidget(UltimateCalculatorApp(key: UniqueKey()));

    await tester.tap(button('5'));
    await tester.pump();

    await tester.tap(button('0'));
    await tester.pump();

    await tester.tap(button('%'));
    await tester.pump();

    await tester.tap(button('='));
    await tester.pump();

    expect(
      double.parse(displayValue(tester)),
      closeTo(0.5, 0.000001),
    );
  });

  testWidgets('25 percent calculates correctly', (tester) async {
    await tester.pumpWidget(UltimateCalculatorApp(key: UniqueKey()));

    await tester.tap(button('2'));
    await tester.pump();

    await tester.tap(button('5'));
    await tester.pump();

    await tester.tap(button('%'));
    await tester.pump();

    await tester.tap(button('='));
    await tester.pump();

    expect(
      double.parse(displayValue(tester)),
      closeTo(0.25, 0.000001),
    );
  });

  testWidgets('2 times 50 percent calculates correctly', (tester) async {
    await tester.pumpWidget(UltimateCalculatorApp(key: UniqueKey()));

    await tester.tap(button('2'));
    await tester.pump();

    await tester.tap(button('×'));
    await tester.pump();

    await tester.tap(button('5'));
    await tester.pump();

    await tester.tap(button('0'));
    await tester.pump();

    await tester.tap(button('%'));
    await tester.pump();

    await tester.tap(button('='));
    await tester.pump();

    expect(
      double.parse(displayValue(tester)),
      closeTo(1, 0.000001),
    );
  });


  testWidgets('sin 90 degrees calculates correctly', (tester) async {
    await tester.pumpWidget(UltimateCalculatorApp(key: UniqueKey()));

    await tester.tap(button('sin'));
    await tester.pump();

    await tester.tap(button('9'));
    await tester.pump();

    await tester.tap(button('0'));
    await tester.pump();

    await tester.tap(button(')'));
    await tester.pump();

    await tester.tap(button('='));
    await tester.pump();

    expect(
      double.parse(displayValue(tester)),
      closeTo(1, 0.000001),
    );
  });

  testWidgets('cos 0 degrees calculates correctly', (tester) async {
    await tester.pumpWidget(UltimateCalculatorApp(key: UniqueKey()));

    await tester.tap(button('cos'));
    await tester.pump();

    await tester.tap(button('0'));
    await tester.pump();

    await tester.tap(button(')'));
    await tester.pump();

    await tester.tap(button('='));
    await tester.pump();

    expect(
      double.parse(displayValue(tester)),
      closeTo(1, 0.000001),
    );
  });

  testWidgets('tan 45 degrees calculates correctly', (tester) async {
    await tester.pumpWidget(UltimateCalculatorApp(key: UniqueKey()));

    await tester.tap(button('tan'));
    await tester.pump();

    await tester.tap(button('4'));
    await tester.pump();

    await tester.tap(button('5'));
    await tester.pump();

    await tester.tap(button(')'));
    await tester.pump();

    await tester.tap(button('='));
    await tester.pump();

    expect(
      double.parse(displayValue(tester)),
      closeTo(1, 0.000001),
    );
  });


  testWidgets('log 100 calculates correctly', (tester) async {
    await tester.pumpWidget(UltimateCalculatorApp(key: UniqueKey()));

    await tester.tap(button('log'));
    await tester.pump();

    await tester.tap(button('1'));
    await tester.pump();

    await tester.tap(button('0'));
    await tester.pump();

    await tester.tap(button('0'));
    await tester.pump();

    await tester.tap(button(')'));
    await tester.pump();

    await tester.tap(button('='));
    await tester.pump();

    expect(
      double.parse(displayValue(tester)),
      closeTo(2, 0.000001),
    );
  });

  testWidgets('log 1000 calculates correctly', (tester) async {
    await tester.pumpWidget(UltimateCalculatorApp(key: UniqueKey()));

    await tester.tap(button('log'));
    await tester.pump();

    await tester.tap(button('1'));
    await tester.pump();

    await tester.tap(button('0'));
    await tester.pump();

    await tester.tap(button('0'));
    await tester.pump();

    await tester.tap(button('0'));
    await tester.pump();

    await tester.tap(button(')'));
    await tester.pump();

    await tester.tap(button('='));
    await tester.pump();

    expect(
      double.parse(displayValue(tester)),
      closeTo(3, 0.000001),
    );
  });

  testWidgets('ln e calculates correctly', (tester) async {
    await tester.pumpWidget(UltimateCalculatorApp(key: UniqueKey()));

    await tester.tap(button('ln'));
    await tester.pump();

    await tester.tap(button('e'));
    await tester.pump();

    await tester.tap(button(')'));
    await tester.pump();

    await tester.tap(button('='));
    await tester.pump();

    expect(
      double.parse(displayValue(tester)),
      closeTo(1, 0.000001),
    );
  });

  testWidgets('ln 1 calculates correctly', (tester) async {
    await tester.pumpWidget(UltimateCalculatorApp(key: UniqueKey()));

    await tester.tap(button('ln'));
    await tester.pump();

    await tester.tap(button('1'));
    await tester.pump();

    await tester.tap(button(')'));
    await tester.pump();

    await tester.tap(button('='));
    await tester.pump();

    expect(
      double.parse(displayValue(tester)),
      closeTo(0, 0.000001),
    );
  });


  testWidgets('5 factorial calculates correctly', (tester) async {
    await tester.pumpWidget(UltimateCalculatorApp(key: UniqueKey()));

    await tester.tap(button('5'));
    await tester.pump();

    await tester.tap(button('!'));
    await tester.pump();

    await tester.tap(button('='));
    await tester.pump();

    expect(
      double.parse(displayValue(tester)),
      closeTo(120, 0.000001),
    );
  });

  testWidgets('0 factorial calculates correctly', (tester) async {
    await tester.pumpWidget(UltimateCalculatorApp(key: UniqueKey()));

    await tester.tap(button('0'));
    await tester.pump();

    await tester.tap(button('!'));
    await tester.pump();

    await tester.tap(button('='));
    await tester.pump();

    expect(
      double.parse(displayValue(tester)),
      closeTo(1, 0.000001),
    );
  });

  testWidgets('10 factorial calculates correctly', (tester) async {
    await tester.pumpWidget(UltimateCalculatorApp(key: UniqueKey()));

    await tester.tap(button('1'));
    await tester.pump();

    await tester.tap(button('0'));
    await tester.pump();

    await tester.tap(button('!'));
    await tester.pump();

    await tester.tap(button('='));
    await tester.pump();

    expect(
      double.parse(displayValue(tester)),
      closeTo(3628800, 0.000001),
    );
  });


  testWidgets('DEG mode calculates sin(90) as 1', (tester) async {
    await tester.pumpWidget(UltimateCalculatorApp(key: UniqueKey()));

    expect(find.widgetWithText(FilledButton, 'DEG'), findsOneWidget);

    await tester.tap(button('sin'));
    await tester.pump();

    await tester.tap(button('9'));
    await tester.pump();

    await tester.tap(button('0'));
    await tester.pump();

    await tester.tap(button(')'));
    await tester.pump();

    await tester.tap(button('='));
    await tester.pump();

    expect(
      double.parse(displayValue(tester)),
      closeTo(1, 0.000001),
    );
  });

  testWidgets('RAD mode calculates sin(pi/2) as 1', (tester) async {
    await tester.pumpWidget(UltimateCalculatorApp(key: UniqueKey()));

    expect(find.widgetWithText(FilledButton, 'DEG'), findsOneWidget);

    await tester.tap(button('DEG'));
    await tester.pump();

    expect(find.widgetWithText(FilledButton, 'RAD'), findsOneWidget);

    await tester.tap(button('sin'));
    await tester.pump();

    await tester.tap(button('π'));
    await tester.pump();

    await tester.tap(button('÷'));
    await tester.pump();

    await tester.tap(button('2'));
    await tester.pump();

    await tester.tap(button(')'));
    await tester.pump();

    await tester.tap(button('='));
    await tester.pump();

    expect(
      double.parse(displayValue(tester)),
      closeTo(1, 0.000001),
    );
  });

  testWidgets('DEG and RAD toggle correctly', (tester) async {
    await tester.pumpWidget(UltimateCalculatorApp(key: UniqueKey()));

    expect(find.widgetWithText(FilledButton, 'DEG'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'RAD'), findsNothing);

    await tester.tap(button('DEG'));
    await tester.pump();

    expect(find.widgetWithText(FilledButton, 'RAD'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'DEG'), findsNothing);

    await tester.tap(button('RAD'));
    await tester.pump();

    expect(find.widgetWithText(FilledButton, 'DEG'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'RAD'), findsNothing);
  });

}
