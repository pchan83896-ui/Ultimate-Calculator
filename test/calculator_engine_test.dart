import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';

import 'package:ultimate_calculator/features/calculator/domain/calculator_engine.dart';

void main() {
  const degrees = CalculatorEngine(
    angleMode: AngleMode.degrees,
  );

  const radians = CalculatorEngine(
    angleMode: AngleMode.radians,
  );

  group('Basic calculations', () {
    test('addition', () {
      expect(degrees.evaluate('1+1'), 2);
    });

    test('subtraction', () {
      expect(degrees.evaluate('10-5'), 5);
    });

    test('multiplication', () {
      expect(degrees.evaluate('5*5'), 25);
    });

    test('division', () {
      expect(degrees.evaluate('100/4'), 25);
    });
  });

  group('Operator precedence', () {
    test('multiplication before addition', () {
      expect(degrees.evaluate('2+3*4'), 14);
    });

    test('parentheses override precedence', () {
      expect(degrees.evaluate('(2+3)*4'), 20);
    });

    test('power', () {
      expect(degrees.evaluate('2^3'), 8);
    });

    test('power is right associative', () {
      expect(degrees.evaluate('2^3^2'), 512);
    });
  });

  group('Percent', () {
    test('percentage', () {
      expect(degrees.evaluate('10%'), 0.1);
    });

    test('percentage calculation', () {
      expect(degrees.evaluate('50*10%'), 5);
    });
  });

  group('Constants', () {
    test('pi', () {
      expect(degrees.evaluate('pi'), closeTo(math.pi, 0.0000001));
    });

    test('e', () {
      expect(degrees.evaluate('e'), closeTo(math.e, 0.0000001));
    });

    test('pi multiplied by two', () {
      expect(
        degrees.evaluate('pi*2'),
        closeTo(math.pi * 2, 0.0000001),
      );
    });
  });

  group('Scientific functions', () {
    test('square root', () {
      expect(degrees.evaluate('sqrt(25)'), 5);
    });

    test('square root with expression', () {
      expect(degrees.evaluate('sqrt(9+7)'), 4);
    });

    test('square', () {
      expect(degrees.evaluate('5^2'), 25);
    });

    test('sine in degrees', () {
      expect(
        degrees.evaluate('sin(30)'),
        closeTo(0.5, 0.0000001),
      );
    });

    test('cosine in degrees', () {
      expect(
        degrees.evaluate('cos(60)'),
        closeTo(0.5, 0.0000001),
      );
    });

    test('tangent in degrees', () {
      expect(
        degrees.evaluate('tan(45)'),
        closeTo(1, 0.0000001),
      );
    });

    test('sine in radians', () {
      expect(
        radians.evaluate('sin(pi/2)'),
        closeTo(1, 0.0000001),
      );
    });

    test('log base 10', () {
      expect(
        degrees.evaluate('log(100)'),
        closeTo(2, 0.0000001),
      );
    });

    test('natural logarithm', () {
      expect(
        degrees.evaluate('ln(e)'),
        closeTo(1, 0.0000001),
      );
    });

    test('factorial', () {
      expect(degrees.evaluate('5!'), 120);
    });

    test('factorial zero', () {
      expect(degrees.evaluate('0!'), 1);
    });
  });

  group('Decimals', () {
    test('decimal calculation', () {
      expect(degrees.evaluate('1.5+2.5'), 4);
    });

    test('floating point tolerance', () {
      expect(
        degrees.evaluate('0.1+0.2'),
        closeTo(0.3, 0.0000001),
      );
    });
  });

  group('Negative numbers', () {
    test('negative number', () {
      expect(degrees.evaluate('-5+10'), 5);
    });

    test('negative multiplication', () {
      expect(degrees.evaluate('-5*2'), -10);
    });
  });

  group('Errors', () {
    test('division by zero throws', () {
      expect(
        () => degrees.evaluate('10/0'),
        throwsA(isA<FormatException>()),
      );
    });

    test('invalid expression throws', () {
      expect(
        () => degrees.evaluate('2+'),
        throwsA(isA<FormatException>()),
      );
    });

    test('empty expression throws', () {
      expect(
        () => degrees.evaluate(''),
        throwsA(isA<FormatException>()),
      );
    });

    test('negative square root throws', () {
      expect(
        () => degrees.evaluate('sqrt(-1)'),
        throwsA(isA<FormatException>()),
      );
    });

    test('invalid logarithm throws', () {
      expect(
        () => degrees.evaluate('log(0)'),
        throwsA(isA<FormatException>()),
      );
    });

    test('invalid factorial throws', () {
      expect(
        () => degrees.evaluate('5.5!'),
        throwsA(isA<FormatException>()),
      );
    });

    test('factorial too large throws', () {
      expect(
        () => degrees.evaluate('171!'),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
