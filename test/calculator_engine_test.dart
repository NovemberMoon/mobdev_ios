import 'package:flutter_test/flutter_test.dart';
import 'package:mobdev_ios/core/calculator_engine.dart';

void main() {
  late CalculatorEngine engine;

  setUp(() {
    engine = CalculatorEngine();
  });

  group('1. Базовые арифметические операции и приоритеты', () {
    test('Сложение и вычитание', () {
      expect(engine.evaluate('10 + 5'), equals(15.0));
      expect(engine.evaluate('20 - 8'), equals(12.0));
    });

    test('Приоритет умножения и деления над сложением', () {
      expect(engine.evaluate('2 + 2 * 2'), equals(6.0));
      expect(engine.evaluate('10 - 6 / 2'), equals(7.0));
      expect(engine.evaluate('3 * 4 + 2 * 5'), equals(22.0));
    });

    test('Вещественные числа с плавающей точкой', () {
      expect(engine.evaluate('2.5 * 4'), equals(10.0));
      expect(engine.evaluate('0.1 + 0.2'), closeTo(0.3, 0.00001));
    });
  });

  group('2. Выражения со скобками', () {
    test('Изменение приоритета скобками', () {
      expect(engine.evaluate('(2 + 2) * 2'), equals(8.0));
      expect(engine.evaluate('10 / (5 - 3)'), equals(5.0));
    });

    test('Вложенные скобки', () {
      expect(engine.evaluate('2 * (3 + (4 * 2))'), equals(22.0));
      expect(engine.evaluate('((1 + 2) * (3 + 4))'), equals(21.0));
    });

    test('Неявное умножение со скобками', () {
      expect(engine.evaluate('2(3 + 4)'), equals(14.0));
      expect(engine.evaluate('(2 + 3)(4)'), equals(20.0));
    });
  });

  group('3. Унарный минус и смена знака', () {
    test('Отрицательное число в начале выражения', () {
      expect(engine.evaluate('-5 + 3'), equals(-2.0));
      expect(engine.evaluate('-10 * -2'), equals(20.0));
    });

    test('Унарный минус перед скобкой', () {
      expect(engine.evaluate('-(2 + 3)'), equals(-5.0));
      expect(engine.evaluate('10 - -(5 - 2)'), equals(13.0));
    });

    test('Вычитание отрицательного числа', () {
      expect(engine.evaluate('5 - -3'), equals(8.0));
    });
  });

  group('4. Контекстный процент (%)', () {
    test('Пользовательский процент после сложения и вычитания', () {
      // 20 + 5% от 20 = 20 + 1 = 21
      expect(engine.evaluate('20 + 5%'), equals(21.0));
      // 100 - 15% от 100 = 100 - 15 = 85
      expect(engine.evaluate('100 - 15%'), equals(85.0));
    });

    test('Математический процент при умножении и делении', () {
      // 200 * 5% = 200 * 0.05 = 10
      expect(engine.evaluate('200 * 5%'), equals(10.0));
      expect(engine.evaluate('50 / 50%'), equals(100.0));
    });
  });

  group('5. Форматирование результата (formatResult)', () {
    test('Целые числа выводятся без дробной части', () {
      expect(engine.formatResult(5.0), equals('5'));
      expect(engine.formatResult(0.0), equals('0'));
      expect(engine.formatResult(-42.0), equals('-42'));
    });

    test('Дробные числа сохраняют знаки', () {
      expect(engine.formatResult(3.14), equals('3.14'));
      expect(engine.formatResult(0.5), equals('0.5'));
    });
  });

  group('6. Обработка ошибок (CalculatorException)', () {
    test('Деление на ноль выбрасывает CalculatorException', () {
      expect(
        () => engine.evaluate('10 / 0'),
        throwsA(isA<CalculatorException>()),
      );
    });

    test('Несбалансированные скобки выбрасывают CalculatorException', () {
      // Не закрыта скобка
      expect(
        () => engine.evaluate('(2 + 3 * 4'),
        throwsA(isA<CalculatorException>()),
      );
      // Лишняя закрывающая скобка
      expect(
        () => engine.evaluate('2 + 3) * 4'),
        throwsA(isA<CalculatorException>()),
      );
    });

    test('Пустое выражение или некорректный ввод', () {
      expect(() => engine.evaluate(''), throwsA(isA<CalculatorException>()));
      expect(() => engine.evaluate('   '), throwsA(isA<CalculatorException>()));
    });
  });
}
