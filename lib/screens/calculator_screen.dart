import 'package:flutter/material.dart';

import '../core/calculator_engine.dart';
import '../models/history_entry.dart';
import '../widgets/calc_button.dart';
import '../widgets/display_area.dart';
import '../widgets/history_panel.dart';

class CalculatorScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const CalculatorScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final CalculatorEngine _engine = CalculatorEngine();

  String _input = '';
  String _result = '0';
  String? _errorMessage;
  double _memory = 0.0;
  bool _isCalculated = false;
  final List<HistoryEntry> _history = [];

  static const List<String> _operators = ['+', '-', '×', '÷', '%'];
  static const List<String> _memoryKeys = ['MC', 'MR', 'M-', 'M+'];

  void _onKeyPress(String key) {
    setState(() {
      if (key == 'AC') {
        _input = '';
        _result = '0';
        _errorMessage = null;
        _isCalculated = false;
        return;
      }

      if (_errorMessage != null) {
        _errorMessage = null;
        if (key != '⌫' && key != '=') {
          _input = '';
          _result = '0';
        }
      }

      if (_isCalculated) {
        _isCalculated = false;
        if (_operators.contains(key)) {
          _input = _result;
        } else if (!_memoryKeys.contains(key) && key != '⌫' && key != '=') {
          _input = '';
          _result = '0';
        }
      }

      switch (key) {
        case '⌫':
          if (_input.isNotEmpty) {
            if (_input.endsWith('(-')) {
              _input = _input.substring(0, _input.length - 2);
            } else {
              _input = _input.substring(0, _input.length - 1);
            }
          }
          break;
        case '=':
          _compute();
          break;
        case '±':
          _toggleSign();
          break;
        case '.':
          _handleDotInput();
          break;
        case 'MC':
          _memory = 0.0;
          break;
        case 'MR':
          final String formattedMemory = _engine.formatResult(_memory);
          if (_input.isEmpty) {
            _input = formattedMemory;
          } else {
            _input += formattedMemory;
          }
          break;
        case 'M+':
          _mutateMemory((val) => _memory += val);
          break;
        case 'M-':
          _mutateMemory((val) => _memory -= val);
          break;
        default:
          if (_operators.contains(key)) {
            _handleOperatorInput(key);
          } else {
            _input += key;
          }
      }
    });
  }

  void _handleDotInput() {
    if (_input.isEmpty) {
      _input = '0.';
      return;
    }
    final lastNumberChunk =
        RegExp(r'(\d*\.?\d*)$').firstMatch(_input)?.group(1) ?? '';
    if (!lastNumberChunk.contains('.')) {
      _input += lastNumberChunk.isEmpty ? '0.' : '.';
    }
  }

  void _handleOperatorInput(String op) {
    if (_input.isEmpty) {
      if (op == '-') _input = '-';
      return;
    }

    if (_input.endsWith('(-')) {
      return;
    }

    final lastChar = _input[_input.length - 1];

    if (op == '-' && (lastChar == '×' || lastChar == '÷' || lastChar == '(')) {
      _input += '(-';
      return;
    }

    if (_operators.contains(lastChar)) {
      _input = _input.substring(0, _input.length - 1) + op;
    } else {
      _input += op;
    }
  }

  void _mutateMemory(void Function(double currentVal) mutation) {
    double? current = double.tryParse(_result);
    if ((current == null || current == 0.0) && _input.isNotEmpty) {
      try {
        current = _engine.evaluate(
          _input.replaceAll('×', '*').replaceAll('÷', '/'),
        );
      } catch (_) {}
    }
    if (current != null) {
      mutation(current);
    }
  }

  void _toggleSign() {
    if (_input.isEmpty) {
      _input = '(-';
      return;
    }

    final trailingNegParen = RegExp(r'\(-(\d+(?:\.\d+)?)\)$');
    final match = trailingNegParen.firstMatch(_input);
    if (match != null) {
      _input = _input.substring(0, match.start) + match.group(1)!;
      return;
    }

    final trailingNum = RegExp(r'(\d+(?:\.\d+)?)$');
    final numMatch = trailingNum.firstMatch(_input);
    if (numMatch != null) {
      _input = '${_input.substring(0, numMatch.start)}(-${numMatch.group(1)!})';
      return;
    }

    if (_input.endsWith('(-')) {
      _input = _input.substring(0, _input.length - 2);
    } else if (_input.endsWith('-')) {
      _input = _input.substring(0, _input.length - 1);
    } else {
      _input += '(-';
    }
  }

  void _compute() {
    if (_input.trim().isEmpty) return;

    final String sanitizedExpression = _input
        .replaceAll('×', '*')
        .replaceAll('÷', '/');

    try {
      final double evaluated = _engine.evaluate(sanitizedExpression);
      final String formatted = _engine.formatResult(evaluated);

      _result = formatted;
      _isCalculated = true;
      _history.insert(
        0,
        HistoryEntry(
          expression: _input,
          result: formatted,
          timestamp: DateTime.now(),
        ),
      );

      if (_history.length > 10) {
        _history.removeLast();
      }
    } on CalculatorException catch (e) {
      _errorMessage = e.message;
      _isCalculated = true;
    } catch (_) {
      _errorMessage = 'Некорректное выражение';
      _isCalculated = true;
    }
  }

  void _showHistoryModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => FractionallySizedBox(
        heightFactor: 0.85,
        child: HistoryPanel(
          history: _history,
          onSelect: (expr) {
            setState(() {
              _input = expr;
              _errorMessage = null;
              _isCalculated = false;
            });
            Navigator.pop(ctx);
          },
          onClear: () {
            setState(() => _history.clear());
            Navigator.pop(ctx);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            final bool isLandscape = orientation == Orientation.landscape;

            if (isLandscape) {
              return Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: DisplayArea(
                      input: _input,
                      result: _result,
                      errorMessage: _errorMessage,
                      hasMemory: _memory != 0.0,
                      isDarkMode: widget.isDarkMode,
                      onThemeToggle: widget.onThemeToggle,
                      onHistoryPressed: () => _showHistoryModal(context),
                    ),
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(flex: 6, child: _buildKeypad(true)),
                ],
              );
            }

            return Column(
              children: [
                Expanded(
                  flex: 3,
                  child: DisplayArea(
                    input: _input,
                    result: _result,
                    errorMessage: _errorMessage,
                    hasMemory: _memory != 0.0,
                    isDarkMode: widget.isDarkMode,
                    onThemeToggle: widget.onThemeToggle,
                    onHistoryPressed: () => _showHistoryModal(context),
                  ),
                ),
                _buildMemoryBar(false),
                const Divider(height: 1),
                Expanded(flex: 7, child: _buildKeypad(false)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMemoryBar(bool isLandscape) {
    const memoryKeys = ['MC', 'MR', 'M-', 'M+'];
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 6.0,
        vertical: isLandscape ? 1.0 : 2.0,
      ),
      child: Row(
        children: memoryKeys
            .map(
              (k) => CalcButton(
                label: k,
                type: ButtonType.action,
                onPressed: () => _onKeyPress(k),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildKeypad(bool isLandscape) {
    return Padding(
      padding: EdgeInsets.all(isLandscape ? 2.0 : 6.0),
      child: Column(
        children: [
          if (isLandscape)
            Expanded(
              child: Row(
                children: ['MC', 'MR', 'M-', 'M+']
                    .map(
                      (k) => CalcButton(
                        label: k,
                        type: ButtonType.action,
                        onPressed: () => _onKeyPress(k),
                      ),
                    )
                    .toList(),
              ),
            ),
          Expanded(
            child: Row(
              children: [
                CalcButton(
                  label: 'AC',
                  type: ButtonType.accent,
                  onPressed: () => _onKeyPress('AC'),
                ),
                CalcButton(
                  label: '⌫',
                  type: ButtonType.action,
                  onPressed: () => _onKeyPress('⌫'),
                ),
                CalcButton(
                  label: '(',
                  type: ButtonType.operator,
                  onPressed: () => _onKeyPress('('),
                ),
                CalcButton(
                  label: ')',
                  type: ButtonType.operator,
                  onPressed: () => _onKeyPress(')'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                CalcButton(
                  label: '±',
                  type: ButtonType.action,
                  onPressed: () => _onKeyPress('±'),
                ),
                CalcButton(
                  label: '%',
                  type: ButtonType.operator,
                  onPressed: () => _onKeyPress('%'),
                ),
                CalcButton(
                  label: '÷',
                  type: ButtonType.operator,
                  onPressed: () => _onKeyPress('÷'),
                ),
                CalcButton(
                  label: '×',
                  type: ButtonType.operator,
                  onPressed: () => _onKeyPress('×'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                CalcButton(label: '7', onPressed: () => _onKeyPress('7')),
                CalcButton(label: '8', onPressed: () => _onKeyPress('8')),
                CalcButton(label: '9', onPressed: () => _onKeyPress('9')),
                CalcButton(
                  label: '-',
                  type: ButtonType.operator,
                  onPressed: () => _onKeyPress('-'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                CalcButton(label: '4', onPressed: () => _onKeyPress('4')),
                CalcButton(label: '5', onPressed: () => _onKeyPress('5')),
                CalcButton(label: '6', onPressed: () => _onKeyPress('6')),
                CalcButton(
                  label: '+',
                  type: ButtonType.operator,
                  onPressed: () => _onKeyPress('+'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                CalcButton(label: '1', onPressed: () => _onKeyPress('1')),
                CalcButton(label: '2', onPressed: () => _onKeyPress('2')),
                CalcButton(label: '3', onPressed: () => _onKeyPress('3')),
                CalcButton(label: '.', onPressed: () => _onKeyPress('.')),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                CalcButton(
                  label: '0',
                  flex: 2,
                  onPressed: () => _onKeyPress('0'),
                ),
                CalcButton(
                  label: '=',
                  flex: 2,
                  type: ButtonType.accent,
                  onPressed: () => _onKeyPress('='),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
