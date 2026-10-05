import 'package:flutter/material.dart';

import 'calculator_controller.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  late final CalculatorController _controller;

  @override
  void initState() {
    super.initState();

    _controller = CalculatorController();
    _controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onControllerChanged)
      ..dispose();

    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _input(String value) {
    _controller.input(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ultimate Calculator'),
        actions: [
          IconButton(
            tooltip: 'Scientific calculator',
            onPressed: () {},
            icon: const Icon(Icons.science_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _buildDisplay(context),
            ),
            _buildKeypad(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDisplay(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_controller.expression.isNotEmpty)
            Text(
              _controller.expression,
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          const SizedBox(height: 8),
          Text(
            _controller.hasError
                ? 'Error'
                : _controller.display,
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          if (_controller.hasError) ...[
            const SizedBox(height: 4),
            Text(
              _controller.error ?? 'Calculation error',
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildKeypad(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: Column(
        children: [
          _buildRow([
            _key(
              'AC',
              onPressed: _controller.clear,
              type: _KeyType.action,
            ),
            _key(
              '⌫',
              onPressed: _controller.backspace,
              type: _KeyType.action,
            ),
            _key(
              '%',
              onPressed: () => _input('%'),
              type: _KeyType.operator,
            ),
            _key(
              '÷',
              onPressed: () => _input('/'),
              type: _KeyType.operator,
            ),
          ]),
          _buildRow([
            _key('7', onPressed: () => _input('7')),
            _key('8', onPressed: () => _input('8')),
            _key('9', onPressed: () => _input('9')),
            _key(
              '×',
              onPressed: () => _input('*'),
              type: _KeyType.operator,
            ),
          ]),
          _buildRow([
            _key('4', onPressed: () => _input('4')),
            _key('5', onPressed: () => _input('5')),
            _key('6', onPressed: () => _input('6')),
            _key(
              '−',
              onPressed: () => _input('-'),
              type: _KeyType.operator,
            ),
          ]),
          _buildRow([
            _key('1', onPressed: () => _input('1')),
            _key('2', onPressed: () => _input('2')),
            _key('3', onPressed: () => _input('3')),
            _key(
              '+',
              onPressed: () => _input('+'),
              type: _KeyType.operator,
            ),
          ]),
          _buildRow([
            _key(
              '0',
              onPressed: () => _input('0'),
              flex: 2,
            ),
            _key(
              '.',
              onPressed: () => _input('.'),
            ),
            _key(
              '=',
              onPressed: _controller.calculate,
              type: _KeyType.equals,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildRow(List<Widget> children) {
    return SizedBox(
      height: 72,
      child: Row(
        children: children,
      ),
    );
  }

  Widget _key(
    String label, {
    required VoidCallback onPressed,
    _KeyType type = _KeyType.number,
    int flex = 1,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    Color? backgroundColor;

    switch (type) {
      case _KeyType.number:
        backgroundColor = colorScheme.surfaceContainerHighest;
      case _KeyType.action:
        backgroundColor = colorScheme.secondaryContainer;
      case _KeyType.operator:
        backgroundColor = colorScheme.primaryContainer;
      case _KeyType.equals:
        backgroundColor = colorScheme.primary;
    }

    final foregroundColor = type == _KeyType.equals
        ? colorScheme.onPrimary
        : colorScheme.onSurface;

    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

enum _KeyType {
  number,
  action,
  operator,
  equals,
}
