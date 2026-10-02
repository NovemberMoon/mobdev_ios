import 'package:flutter_test/flutter_test.dart';
import 'package:mobdev_ios/core/calculator_engine.dart';
import 'package:mobdev_ios/models/history_entry.dart';

void main() {
  late CalculatorEngine engine;

  setUp(() {
    engine = CalculatorEngine();
  });

  group('1. Вычисление математических операций и приоритет', () {
    test('Сложение, вычитание, умножение, деление', () {
      expect(engine.evaluate('10 + 5'), equals(15.0));
      expect(engine.evaluate('20 - 8'), equals(12.0));
      expect(engine.evaluate('6 * 7'), equals(42.0));
      expect(engine.evaluate('7 / 2'), equals(3.5));
      expect(engine.evaluate('15.5 * 2'), equals(31.0));
    });

    test('Приоритет умножения и деления над сложением и вычитанием', () {
      expect(engine.evaluate('2 + 2 * 2'), equals(6.0));
      expect(engine.evaluate('10 - 6 / 2'), equals(7.0));
      expect(engine.evaluate('12 + 5 * 3'), equals(27.0));
      expect(engine.evaluate('20 / 4 + 7'), equals(12.0));
    });

    test('Последовательные цепочки операций', () {
      expect(engine.evaluate('1 + 2 + 3 + 4 - 5'), equals(5.0));
      expect(engine.evaluate('100 / 2 / 5'), equals(10.0));
    });

    test('Точность вещественных чисел с плавающей точкой', () {
      expect(engine.evaluate('2.5 * 4'), equals(10.0));
      final res = engine.evaluate('0.1 + 0.2');
      expect(engine.formatResult(res), equals('0.3'));
    });
  });

  group('2. Выражения со скобками и неявное умножение', () {
    test('Изменение приоритета при помощи скобок', () {
      expect(engine.evaluate('(2 + 2) * 2'), equals(8.0));
      expect(engine.evaluate('(12 + 5) * 3'), equals(51.0));
      expect(engine.evaluate('10 / (5 - 3)'), equals(5.0));
    });

    test('Вложенные скобки разной глубины', () {
      expect(engine.evaluate('2 * (3 + (4 * 2))'), equals(22.0));
      expect(engine.evaluate('((1 + 2) * (3 + 4))'), equals(21.0));
    });

    test('Неявное умножение рядом со скобками', () {
      expect(engine.evaluate('2(3 + 4)'), equals(14.0));
      expect(engine.evaluate('(2 + 3)(4)'), equals(20.0));
      expect(engine.evaluate('(2 + 3)(4 + 5)'), equals(45.0));
    });
  });

  group('3. Унарный минус и отрицательные числа', () {
    test('Отрицательное число в начале и внутри выражения', () {
      expect(engine.evaluate('-5 + 3'), equals(-2.0));
      expect(engine.evaluate('-10 * -2'), equals(20.0));
      expect(engine.evaluate('-5 + -3'), equals(-8.0));
    });

    test('Унарный минус перед скобкой и внутри скобок', () {
      expect(engine.evaluate('-(2 + 3)'), equals(-5.0));
      expect(engine.evaluate('10 - -(5 - 2)'), equals(13.0));
      expect(engine.evaluate('(12 + (-5)) * 3'), equals(21.0));
    });

    test('Вычитание отрицательного числа', () {
      expect(engine.evaluate('5 - -3'), equals(8.0));
    });
  });

  group('4. Операции с процентом (%)', () {
    test('Относительный процент после операций сложения и вычитания', () {
      expect(engine.evaluate('20 + 5%'), equals(21.0));
      expect(engine.evaluate('100 - 15%'), equals(85.0));
    });

    test('Абсолютный процент при умножении и делении', () {
      expect(engine.evaluate('200 * 5%'), equals(10.0));
      expect(engine.evaluate('50 / 50%'), equals(100.0));
    });
  });

  group('5. Форматирование результата (formatResult)', () {
    test('Целые числа отсекают дробную часть', () {
      expect(engine.formatResult(5.0), equals('5'));
      expect(engine.formatResult(0.0), equals('0'));
      expect(engine.formatResult(-42.0), equals('-42'));
    });

    test('Дробные числа выравнивают точность', () {
      expect(engine.formatResult(3.14), equals('3.14'));
      expect(engine.formatResult(0.5), equals('0.5'));
    });

    test('Обработка деления на ноль и нечисловых значений', () {
      expect(engine.formatResult(double.infinity), equals('Error'));
      expect(engine.formatResult(double.nan), equals('Error'));
    });
  });

  group('6. Валидация ошибок и исключения (CalculatorException)', () {
    test('Деление на ноль выбрасывает исключение', () {
      expect(
        () => engine.evaluate('10 / 0'),
        throwsA(
          isA<CalculatorException>().having(
            (e) => e.message,
            'message',
            contains('Деление на ноль'),
          ),
        ),
      );
    });

    test('Несбалансированные скобки', () {
      expect(
        () => engine.evaluate('(2 + 3 * 4'),
        throwsA(
          isA<CalculatorException>().having(
            (e) => e.message,
            'message',
            contains('скобка'),
          ),
        ),
      );
      expect(
        () => engine.evaluate('2 + 3) * 4'),
        throwsA(
          isA<CalculatorException>().having(
            (e) => e.message,
            'message',
            contains('скобка'),
          ),
        ),
      );
    });

    test('Пустой или пробельный ввод', () {
      expect(() => engine.evaluate(''), throwsA(isA<CalculatorException>()));
      expect(() => engine.evaluate('   '), throwsA(isA<CalculatorException>()));
    });

    test('Выражение с лишним оператором в конце', () {
      expect(
        () => engine.evaluate('10 +'),
        throwsA(isA<CalculatorException>()),
      );
    });

    test('Недопустимый символ в выражении', () {
      expect(
        () => engine.evaluate('10 + abc'),
        throwsA(isA<CalculatorException>()),
      );
    });
  });

  group('7. Структура данных истории (HistoryEntry)', () {
    test('Экземпляр HistoryEntry корректно сохраняет свойства', () {
      final now = DateTime.now();
      final entry = HistoryEntry(
        expression: '10 + 5',
        result: '15',
        timestamp: now,
      );

      expect(entry.expression, equals('10 + 5'));
      expect(entry.result, equals('15'));
      expect(entry.timestamp, equals(now));
    });
  });
}
