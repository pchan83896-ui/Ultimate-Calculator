import 'package:flutter/foundation.dart';

import '../domain/calculator_engine.dart';

class CalculatorController extends ChangeNotifier {
  CalculatorController({
    CalculatorEngine? engine,
  }) : _engine = engine ?? const CalculatorEngine();

  CalculatorEngine _engine;

  String _expression = '';
  String _display = '0';
  String? _error;
  AngleMode _angleMode = AngleMode.degrees;
  bool _justCalculated = false;
  String? _lastOperator;
  String? _lastOperand;

  String get expression => _expression;
  String get display => _display;
  String? get error => _error;

  bool get hasError => _error != null;

  AngleMode get angleMode => _angleMode;

  String get angleModeLabel {
    return _angleMode == AngleMode.degrees ? 'DEG' : 'RAD';
  }

  void toggleAngleMode() {
    _angleMode = _angleMode == AngleMode.degrees
        ? AngleMode.radians
        : AngleMode.degrees;

    _engine = CalculatorEngine(angleMode: _angleMode);

    _error = null;
    _updatePreview();
    notifyListeners();
  }

  void input(String value) {
    if (value.isEmpty) {
      return;
    }

    if (_error != null) {
      _expression = '';
      _display = '0';
      _justCalculated = false;
      _lastOperator = null;
      _lastOperand = null;
    }

    _error = null;

    if (_justCalculated) {
      if (_isOperator(value)) {
        _expression = _display;
      } else {
        _expression = '';
      }

      _justCalculated = false;
    }

    if (_isOperator(value)) {
      _inputOperator(value);
    } else if (value == '.') {
      _inputDecimal();
    } else if (value == ')') {
      _inputClosingParenthesis();
    } else {
      _expression += value;
    }

    _updatePreview();
    notifyListeners();
  }

  bool _isOperator(String value) {
    return value == '+' ||
        value == '-' ||
        value == '*' ||
        value == '/' ||
        value == '^';
  }

  void _inputOperator(String operator) {
    if (_expression.isEmpty) {
      if (operator == '-') {
        _expression = '-';
      }
      return;
    }

    final last = _expression[_expression.length - 1];

    if (_isOperator(last)) {
      if (operator == '-' && last != '-') {
        _expression += operator;
        return;
      }

      if (last == '-') {
        if (_expression.length >= 2 &&
            _isOperator(_expression[_expression.length - 2])) {
          return;
        }

        _expression += operator;
        return;
      }

      _expression =
          '${_expression.substring(0, _expression.length - 1)}$operator';
      return;
    }

    if (last == '(') {
      if (operator == '-') {
        _expression += operator;
      }
      return;
    }

    _expression += operator;
  }

  void _inputDecimal() {
    var index = _expression.length - 1;

    while (index >= 0 && !_isExpressionSeparator(_expression[index])) {
      index--;
    }

    final currentNumber = _expression.substring(index + 1);

    if (currentNumber.contains('.')) {
      return;
    }

    if (currentNumber.isEmpty) {
      _expression += '0.';
    } else {
      _expression += '.';
    }
  }

  bool _isExpressionSeparator(String value) {
    return _isOperator(value) || value == '(' || value == ')';
  }

  void _inputClosingParenthesis() {
    if (_expression.isEmpty) {
      return;
    }

    final openCount = '('.allMatches(_expression).length;
    final closeCount = ')'.allMatches(_expression).length;

    if (openCount <= closeCount) {
      return;
    }

    final last = _expression[_expression.length - 1];

    if (_isOperator(last) || last == '(' || last == '.') {
      return;
    }

    _expression += ')';
  }

  void backspace() {
    if (_expression.isEmpty) {
      return;
    }

    _error = null;
    _expression = _expression.substring(
      0,
      _expression.length - 1,
    );

    _updatePreview();
    notifyListeners();
  }

  void toggleSign() {
    _error = null;

    if (_expression.isEmpty) {
      _expression = '-';
      _updatePreview();
      notifyListeners();
      return;
    }

    final operators = RegExp(r'[+*/^\-]');
    var start = _expression.length - 1;

    while (start >= 0 && !operators.hasMatch(_expression[start])) {
      start--;
    }

    final numberStart = start + 1;

    if (numberStart < _expression.length &&
        _expression[numberStart] == '-') {
      _expression =
          '${_expression.substring(0, numberStart)}'
          '${_expression.substring(numberStart + 1)}';
    } else {
      _expression =
          '${_expression.substring(0, numberStart)}'
          '-${_expression.substring(numberStart)}';
    }

    _updatePreview();
    notifyListeners();
  }

  void clear() {
    _expression = '';
    _display = '0';
    _error = null;
    _justCalculated = false;
    _lastOperator = null;
    _lastOperand = null;
    notifyListeners();
  }

  void calculate() {
    if (_justCalculated &&
        _lastOperator != null &&
        _lastOperand != null) {
      _expression = '$_display$_lastOperator$_lastOperand';
    }

    if (_expression.trim().isEmpty) {
      return;
    }

    try {
      if (!_justCalculated) {
        _rememberLastOperation();
      }

      final result = _engine.evaluate(_expression);

      _display = _formatResult(result);
      _error = null;
      _justCalculated = true;
    } on FormatException catch (exception) {
      _error = exception.message;
    } catch (_) {
      _error = 'Calculation error';
    }

    notifyListeners();
  }

  void _rememberLastOperation() {
    final match = RegExp(
      r'^(.+)([+*/^])([^+*/^]+)$',
    ).firstMatch(_expression);

    if (match != null) {
      _lastOperator = match.group(2);
      _lastOperand = match.group(3);
      return;
    }

    final subtractionMatch = RegExp(
      r'^(.+)-([0-9.]+)$',
    ).firstMatch(_expression);

    if (subtractionMatch != null) {
      _lastOperator = '-';
      _lastOperand = subtractionMatch.group(2);
      return;
    }

    _lastOperator = null;
    _lastOperand = null;
  }

  void _updatePreview() {
    if (_expression.isEmpty) {
      _display = '0';
      return;
    }

    try {
      final result = _engine.evaluate(_expression);
      _display = _formatResult(result);
    } catch (_) {
      // The expression may be incomplete while typing.
      // Keep the current expression visible.
      _display = _expression;
    }
  }

  String _formatResult(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    final text = value.toStringAsFixed(10);

    return text
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');
  }
}
