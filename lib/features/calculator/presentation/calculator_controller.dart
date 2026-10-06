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
    _error = null;
    _expression += value;
    _updatePreview();
    notifyListeners();
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
    notifyListeners();
  }

  void calculate() {
    if (_expression.trim().isEmpty) {
      return;
    }

    try {
      final result = _engine.evaluate(_expression);

      _display = _formatResult(result);
      _error = null;
    } on FormatException catch (exception) {
      _error = exception.message;
    } catch (_) {
      _error = 'Calculation error';
    }

    notifyListeners();
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
