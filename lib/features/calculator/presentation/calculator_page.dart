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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _input(String value) {
    setState(() {
      _controller.input(value);
    });
  }

  void _calculate() {
    setState(() {
      _controller.calculate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ultimate Calculator'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.science_outlined),
            tooltip: 'Scientific Calculator',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: _buildDisplay(),
            ),
            Expanded(
              flex: 5,
              child: _buildKeypad(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisplay() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      alignment: Alignment.bottomRight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_controller.expression.isNotEmpty)
            Text(
              _controller.expression,
              style: Theme.of(context).textTheme.titleMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          const SizedBox(height: 8),
          Text(
            _controller.display,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (_controller.error != null) ...[
            const SizedBox(height: 8),
            Text(
              _controller.error!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildKeypad() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                _key('±', onPressed: _controller.toggleSign),
                _key('(', onPressed: () => _input('(')),
                _key(')', onPressed: () => _input(')')),
                _key('√', onPressed: () => _input('sqrt(')),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                _key('AC', onPressed: _controller.clear),
                _key('⌫', onPressed: _controller.backspace),
                _key('%', onPressed: () => _input('%')),
                _key('÷', onPressed: () => _input('/')),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                _key('7', onPressed: () => _input('7')),
                _key('8', onPressed: () => _input('8')),
                _key('9', onPressed: () => _input('9')),
                _key('×', onPressed: () => _input('*')),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                _key('4', onPressed: () => _input('4')),
                _key('5', onPressed: () => _input('5')),
                _key('6', onPressed: () => _input('6')),
                _key('−', onPressed: () => _input('-')),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                _key('1', onPressed: () => _input('1')),
                _key('2', onPressed: () => _input('2')),
                _key('3', onPressed: () => _input('3')),
                _key('+', onPressed: () => _input('+')),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                _key(
                  '0',
                  flex: 2,
                  onPressed: () => _input('0'),
                ),
                _key('.', onPressed: () => _input('.')),
                _key('=', onPressed: _calculate),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _key(
    String label, {
    int flex = 1,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: FilledButton(
          onPressed: () {
            onPressed();
            setState(() {});
          },
          style: FilledButton.styleFrom(
            padding: EdgeInsets.zero,
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
