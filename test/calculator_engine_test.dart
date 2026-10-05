import 'package:flutter_test/flutter_test.dart';

import 'package:ultimate_calculator/features/calculator/domain/calculator_engine.dart';

void main() {
  const engine = CalculatorEngine();

  group('Basic calculations', () {
    test('addition', () {
      expect(engine.evaluate('1+1'), 2);
    });

    test('subtraction', () {
      expect(engine.evaluate('10-5'), 5);
    });

    test('multiplication', () {
      expect(engine.evaluate('5*5'), 25);
    });

    test('division', () {
      expect(engine.evaluate('100/4'), 25);
    });
  });

  group('Operator precedence', () {
    test('multiplication before addition', () {
      expect(engine.evaluate('2+3*4'), 14);
    });

    test('parentheses override precedence', () {
      expect(engine.evaluate('(2+3)*4'), 20);
    });
  });

  group('Decimals', () {
    test('decimal calculation', () {
      expect(engine.evaluate('1.5+2.5'), 4);
    });

    test('zero point two calculation', () {
      expect(engine.evaluate('0.1+0.2'), closeTo(0.3, 0.0000001));
    });
  });

  group('Negative numbers', () {
    test('negative number', () {
      expect(engine.evaluate('-5+10'), 5);
    });

    test('negative multiplication', () {
      expect(engine.evaluate('-5*2'), -10);
    });
  });

  group('Errors', () {
    test('division by zero throws', () {
      expect(
        () => engine.evaluate('10/0'),
        throwsA(isA<FormatException>()),
      );
    });

    test('invalid expression throws', () {
      expect(
        () => engine.evaluate('2+'),
        throwsA(isA<FormatException>()),
      );
    });

    test('empty expression throws', () {
      expect(
        () => engine.evaluate(''),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
