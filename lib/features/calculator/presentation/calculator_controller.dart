import 'package:flutter/foundation.dart';

import '../domain/calculator_engine.dart';

class CalculatorController extends ChangeNotifier {
  CalculatorController({
    CalculatorEngine? engine,
  }) : _engine = engine ?? const CalculatorEngine();

  final CalculatorEngine _engine;

  String _expression = '';
  String _display = '0';
  String? _error;

  String get expression => _expression;
  String get display => _display;
  String? get error => _error;

  bool get hasError => _error != null;

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
