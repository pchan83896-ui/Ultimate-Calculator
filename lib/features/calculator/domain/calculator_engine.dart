class CalculatorEngine {
  const CalculatorEngine();

  double evaluate(String expression) {
    final parser = _ExpressionParser(expression);
    return parser.parse();
  }
}

class _ExpressionParser {
  _ExpressionParser(String expression)
      : _tokens = _tokenize(expression),
        _position = 0;

  final List<String> _tokens;
  int _position;

  double parse() {
    if (_tokens.isEmpty) {
      throw const FormatException('Empty expression');
    }

    final result = _parseExpression();

    if (_position != _tokens.length) {
      throw const FormatException('Invalid expression');
    }

    if (result.isNaN || result.isInfinite) {
      throw const FormatException('Invalid result');
    }

    return result;
  }

  double _parseExpression() {
    var value = _parseTerm();

    while (_position < _tokens.length) {
      final operator = _tokens[_position];

      if (operator == '+' || operator == '-') {
        _position++;
        final right = _parseTerm();

        if (operator == '+') {
          value += right;
        } else {
          value -= right;
        }
      } else {
        break;
      }
    }

    return value;
  }

  double _parseTerm() {
    var value = _parseFactor();

    while (_position < _tokens.length) {
      final operator = _tokens[_position];

      if (operator == '*' || operator == '/') {
        _position++;
        final right = _parseFactor();

        if (operator == '*') {
          value *= right;
        } else {
          if (right == 0) {
            throw const FormatException('Division by zero');
          }

          value /= right;
        }
      } else {
        break;
      }
    }

    return value;
  }

  double _parseFactor() {
    if (_position >= _tokens.length) {
      throw const FormatException('Missing value');
    }

    final token = _tokens[_position];

    if (token == '+') {
      _position++;
      return _parseFactor();
    }

    if (token == '-') {
      _position++;
      return -_parseFactor();
    }

    if (token == '(') {
      _position++;

      final value = _parseExpression();

      if (_position >= _tokens.length || _tokens[_position] != ')') {
        throw const FormatException('Missing closing parenthesis');
      }

      _position++;
      return value;
    }

    if (token == ')') {
      throw const FormatException('Unexpected closing parenthesis');
    }

    _position++;

    final value = double.tryParse(token);

    if (value == null) {
      throw const FormatException('Invalid number');
    }

    return value;
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

      if ('+-*/()'.contains(char)) {
        flushNumber();
        tokens.add(char);
        continue;
      }

      if (char.trim().isEmpty) {
        continue;
      }

      throw FormatException('Invalid character: $char');
    }

    flushNumber();

    return tokens;
  }
}
