class CalculatorException implements Exception {
  final String message;
  const CalculatorException(this.message);

  @override
  String toString() => message;
}

class CalculatorEngine {
  double evaluate(String rawInput) {
    final List<String> tokens = _tokenize(rawInput);
    return _compute(tokens);
  }

  List<String> _tokenize(String rawInput) {
    final String expression = rawInput.replaceAll(' ', '');
    if (expression.isEmpty) {
      throw const CalculatorException('Введите выражение');
    }

    final List<String> tokens = [];
    final StringBuffer numberBuffer = StringBuffer();
    const Set<String> operators = {'+', '-', '*', '/', '%'};

    void flushNumber() {
      if (numberBuffer.isNotEmpty) {
        tokens.add(numberBuffer.toString());
        numberBuffer.clear();
      }
    }

    for (int i = 0; i < expression.length; i++) {
      final String char = expression[i];

      if (RegExp(r'[0-9.]').hasMatch(char)) {
        if (numberBuffer.isEmpty && tokens.isNotEmpty && tokens.last == ')') {
          tokens.add('*');
        }
        numberBuffer.write(char);
      } else if (char == '(') {
        if (numberBuffer.isNotEmpty) {
          flushNumber();
          tokens.add('*');
        } else if (tokens.isNotEmpty && tokens.last == ')') {
          tokens.add('*');
        }
        tokens.add('(');
      } else if (char == ')') {
        flushNumber();
        tokens.add(')');
      } else if (operators.contains(char)) {
        final bool isUnary =
            numberBuffer.isEmpty &&
            (tokens.isEmpty ||
                tokens.last == '(' ||
                operators.contains(tokens.last));

        if (char == '-' && isUnary) {
          tokens.add('u-');
        } else if (char == '+' && isUnary) {
          continue;
        } else {
          flushNumber();
          tokens.add(char);
        }
      } else {
        throw CalculatorException('Недопустимый символ "$char"');
      }
    }

    flushNumber();
    return tokens;
  }

  int _precedence(String op) => switch (op) {
    'u-' => 3,
    '*' || '/' => 2,
    '+' || '-' => 1,
    _ => 0,
  };

  double _compute(List<String> tokens) {
    final List<double> values = [];
    final List<String> operators = [];

    for (int i = 0; i < tokens.length; i++) {
      final String token = tokens[i];
      final double? number = double.tryParse(token);

      if (number != null) {
        values.add(number);
        continue;
      }

      if (token == '(') {
        operators.add(token);
      } else if (token == ')') {
        while (operators.isNotEmpty && operators.last != '(') {
          _executeTopOp(values, operators);
        }
        if (operators.isEmpty) {
          throw const CalculatorException('Пропущена открывающая скобка');
        }
        operators.removeLast();
      } else if (token == '%') {
        _applyPercent(values, operators);
      } else if (token == 'u-') {
        operators.add(token);
      } else {
        while (operators.isNotEmpty &&
            operators.last != '(' &&
            _precedence(operators.last) >= _precedence(token)) {
          _executeTopOp(values, operators);
        }
        operators.add(token);
      }
    }

    while (operators.isNotEmpty) {
      final String op = operators.last;
      if (op == '(' || op == ')') {
        throw const CalculatorException('Пропущена закрывающая скобка');
      }
      _executeTopOp(values, operators);
    }

    if (values.length != 1) {
      throw const CalculatorException('Некорректное выражение');
    }

    return values.single;
  }

  void _executeTopOp(List<double> values, List<String> operators) {
    if (operators.isEmpty) {
      throw const CalculatorException('Некорректное выражение');
    }

    final String op = operators.removeLast();
    if (op == 'u-') {
      _applyUnaryOp(op, values);
    } else {
      _applyBinaryOp(op, values);
    }
  }

  void _applyUnaryOp(String op, List<double> values) {
    if (values.isEmpty) {
      throw const CalculatorException('Пропущено число');
    }

    final double val = values.removeLast();
    if (op == 'u-') {
      values.add(-val);
    } else {
      throw CalculatorException('Неизвестная операция "$op"');
    }
  }

  void _applyBinaryOp(String op, List<double> values) {
    if (values.length < 2) {
      throw const CalculatorException('Пропущено число');
    }

    final double b = values.removeLast();
    final double a = values.removeLast();

    switch (op) {
      case '+':
        values.add(a + b);
      case '-':
        values.add(a - b);
      case '*':
        values.add(a * b);
      case '/':
        if (b == 0.0) {
          throw const CalculatorException('Деление на ноль невозможно');
        }
        values.add(a / b);
      default:
        throw CalculatorException('Неизвестный оператор "$op"');
    }
  }

  void _applyPercent(List<double> values, List<String> operators) {
    if (values.isEmpty) {
      throw const CalculatorException('Пропущено число перед %');
    }

    final double b = values.removeLast();

    if (operators.isNotEmpty &&
        (operators.last == '+' || operators.last == '-')) {
      if (values.isNotEmpty) {
        final double base = values.last;
        values.add(base * (b / 100.0));
        return;
      }
    }

    values.add(b / 100.0);
  }

  String formatResult(double value) {
    if (value.isInfinite || value.isNaN) {
      return 'Error';
    }
    final double rounded = double.parse(value.toStringAsPrecision(12));
    if (rounded % 1 == 0) {
      return rounded.toInt().toString();
    }
    return rounded.toString();
  }
}
