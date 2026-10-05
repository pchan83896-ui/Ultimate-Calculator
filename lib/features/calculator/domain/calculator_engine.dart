import 'dart:math' as math;

enum AngleMode {
  degrees,
  radians,
}

class CalculatorEngine {
  const CalculatorEngine({
    this.angleMode = AngleMode.degrees,
  });

  final AngleMode angleMode;

  double evaluate(String expression) {
    final parser = _ExpressionParser(
      expression,
      angleMode: angleMode,
    );

    final result = parser.parse();

    if (result.isNaN || result.isInfinite) {
      throw const FormatException('Invalid result');
    }

    return result;
  }
}

class _ExpressionParser {
  _ExpressionParser(
    String expression, {
    required this.angleMode,
  })  : _tokens = _tokenize(expression),
        _position = 0;

  final List<String> _tokens;
  final AngleMode angleMode;
  int _position;

  double parse() {
    if (_tokens.isEmpty) {
      throw const FormatException('Empty expression');
    }

    final result = _parseExpression();

    if (_position != _tokens.length) {
      throw const FormatException('Invalid expression');
    }

    return result;
  }

  // + -
  double _parseExpression() {
    var value = _parseTerm();

    while (_position < _tokens.length) {
      final operator = _tokens[_position];

      if (operator != '+' && operator != '-') {
        break;
      }

      _position++;
      final right = _parseTerm();

      if (operator == '+') {
        value += right;
      } else {
        value -= right;
      }
    }

    return value;
  }

  // * /
  double _parseTerm() {
    var value = _parsePower();

    while (_position < _tokens.length) {
      final operator = _tokens[_position];

      if (operator != '*' && operator != '/') {
        break;
      }

      _position++;
      final right = _parsePower();

      if (operator == '*') {
        value *= right;
      } else {
        if (right == 0) {
          throw const FormatException('Division by zero');
        }

        value /= right;
      }
    }

    return value;
  }

  // ^
  double _parsePower() {
    var value = _parseUnary();

    if (_position < _tokens.length && _tokens[_position] == '^') {
      _position++;

      final exponent = _parsePower();
      value = math.pow(value, exponent).toDouble();
    }

    return value;
  }

  // + -
  double _parseUnary() {
    if (_position >= _tokens.length) {
      throw const FormatException('Missing value');
    }

    final token = _tokens[_position];

    if (token == '+') {
      _position++;
      return _parseUnary();
    }

    if (token == '-') {
      _position++;
      return -_parseUnary();
    }

    return _parsePostfix();
  }

  // %, !
  double _parsePostfix() {
    var value = _parsePrimary();

    while (_position < _tokens.length) {
      final token = _tokens[_position];

      if (token == '%') {
        _position++;
        value /= 100;
        continue;
      }

      if (token == '!') {
        _position++;
        value = _factorial(value);
        continue;
      }

      break;
    }

    return value;
  }

  double _parsePrimary() {
    if (_position >= _tokens.length) {
      throw const FormatException('Missing value');
    }

    final token = _tokens[_position];

    if (token == '(') {
      _position++;

      final value = _parseExpression();

      if (_position >= _tokens.length || _tokens[_position] != ')') {
        throw const FormatException('Missing closing parenthesis');
      }

      _position++;

      return value;
    }

    if (_isFunction(token)) {
      return _parseFunction();
    }

    if (token == 'pi') {
      _position++;
      return math.pi;
    }

    if (token == 'e') {
      _position++;
      return math.e;
    }

    _position++;

    final value = double.tryParse(token);

    if (value == null) {
      throw FormatException('Invalid number: $token');
    }

    return value;
  }

  double _parseFunction() {
    final function = _tokens[_position];
    _position++;

    if (_position >= _tokens.length || _tokens[_position] != '(') {
      throw FormatException('$function requires parentheses');
    }

    _position++;

    final value = _parseExpression();

    if (_position >= _tokens.length || _tokens[_position] != ')') {
      throw const FormatException('Missing closing parenthesis');
    }

    _position++;

    switch (function) {
      case 'sqrt':
        if (value < 0) {
          throw const FormatException('Invalid square root');
        }

        return math.sqrt(value);

      case 'sin':
        return math.sin(_toRadians(value));

      case 'cos':
        return math.cos(_toRadians(value));

      case 'tan':
        return math.tan(_toRadians(value));

      case 'log':
        if (value <= 0) {
          throw const FormatException('Invalid logarithm');
        }

        return math.log(value) / math.ln10;

      case 'ln':
        if (value <= 0) {
          throw const FormatException('Invalid natural logarithm');
        }

        return math.log(value);

      default:
        throw FormatException('Unknown function: $function');
    }
  }

  double _toRadians(double value) {
    if (angleMode == AngleMode.radians) {
      return value;
    }

    return value * math.pi / 180;
  }

  double _factorial(double value) {
    if (value < 0 || value != value.roundToDouble()) {
      throw const FormatException('Invalid factorial');
    }

    if (value > 170) {
      throw const FormatException('Factorial too large');
    }

    var result = 1.0;

    for (var i = 2; i <= value.toInt(); i++) {
      result *= i;
    }

    return result;
  }

  bool _isFunction(String token) {
    return token == 'sqrt' ||
        token == 'sin' ||
        token == 'cos' ||
        token == 'tan' ||
        token == 'log' ||
        token == 'ln';
  }

  static List<String> _tokenize(String expression) {
    final tokens = <String>[];
    var currentNumber = '';

    void flushNumber() {
      if (currentNumber.isNotEmpty) {
        tokens.add(currentNumber);
        currentNumber = '';
      }
    }

    for (var i = 0; i < expression.length; i++) {
      final char = expression[i];

      if ('0123456789.'.contains(char)) {
        currentNumber += char;
        continue;
      }

      if ('+-*/^%()!'.contains(char)) {
        flushNumber();
        tokens.add(char);
        continue;
      }

      if (char.trim().isEmpty) {
        continue;
      }

      if (expression.substring(i).startsWith('sqrt')) {
        flushNumber();
        tokens.add('sqrt');
        i += 3;
        continue;
      }

      if (expression.substring(i).startsWith('sin')) {
        flushNumber();
        tokens.add('sin');
        i += 2;
        continue;
      }

      if (expression.substring(i).startsWith('cos')) {
        flushNumber();
        tokens.add('cos');
        i += 2;
        continue;
      }

      if (expression.substring(i).startsWith('tan')) {
        flushNumber();
        tokens.add('tan');
        i += 2;
        continue;
      }

      if (expression.substring(i).startsWith('log')) {
        flushNumber();
        tokens.add('log');
        i += 2;
        continue;
      }

      if (expression.substring(i).startsWith('ln')) {
        flushNumber();
        tokens.add('ln');
        i += 1;
        continue;
      }

      if (expression.substring(i).startsWith('pi')) {
        flushNumber();
        tokens.add('pi');
        i += 1;
        continue;
      }

      if (char == 'e') {
        flushNumber();
        tokens.add('e');
        continue;
      }

      throw FormatException('Invalid character: $char');
    }

    flushNumber();

    return tokens;
  }
}
