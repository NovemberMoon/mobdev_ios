import 'package:contacts_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'support/fake_contacts_service.dart';

void main() {
  late FakeContactsService service;

  setUp(() {
    service = FakeContactsService(contacts: sampleContacts());
  });

  Future<void> pumpApp(
    WidgetTester tester, {
    Locale locale = const Locale('ru'),
  }) async {
    tester.platformDispatcher.localesTestValue = [locale];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    await tester.pumpWidget(ContactsApp(service: service));
    await tester.pumpAndSettle();
  }

  Future<void> setLandscape(WidgetTester tester) async {
    tester.view
      ..physicalSize = const Size(2400, 1080)
      ..devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpAndSettle();
  }

  testWidgets('Отображает список контактов и счетчик с правильным окончанием', (
    tester,
  ) async {
    await pumpApp(tester);

    expect(find.text('Анна Иванова'), findsOneWidget);
    expect(find.text('Найдено: 5 контактов'), findsOneWidget);
    expect(find.text('Без имени'), findsOneWidget);
  });

  testWidgets('Поиск фильтрует контакты и очищается по крестику', (
    tester,
  ) async {
    await pumpApp(tester);

    await tester.enterText(find.byType(TextField), 'Анна');
    await tester.pump();

    expect(find.text('Анна Иванова'), findsOneWidget);
    expect(find.text('Борис Петров'), findsNothing);
    expect(find.text('Найдено: 1 контакт'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pump();

    expect(find.text('Борис Петров'), findsOneWidget);
    expect(service.fetchCalls, 1);
  });

  testWidgets('Переход в детали и возврат назад не перезагружают контакты', (
    tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.text('Анна Иванова'));
    await tester.pumpAndSettle();

    expect(find.text('+7 495 000-00-02'), findsOneWidget);
    expect(find.text('anna@example.org'), findsOneWidget);
    expect(find.text('ООО Ромашка'), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.text('Анна Иванова'), findsOneWidget);
    expect(service.fetchCalls, 1);
  });

  testWidgets('Поворот экрана в ландшафт не сбрасывает введенный поиск', (
    tester,
  ) async {
    await pumpApp(tester);

    await tester.enterText(find.byType(TextField), 'Борис');
    await tester.pump();

    expect(find.text('Борис Петров'), findsOneWidget);

    await setLandscape(tester);

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.controller?.text, 'Борис');
    expect(find.text('Борис Петров'), findsOneWidget);
    expect(service.fetchCalls, 1);
  });
}
