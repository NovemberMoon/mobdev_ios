import 'package:contacts_app/controllers/contacts_controller.dart';
import 'package:contacts_app/models/contacts_view_state.dart';
import 'package:contacts_app/services/contacts_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'support/fake_contacts_service.dart';

void main() {
  late FakeContactsService service;
  late ContactsController controller;

  List<String> visibleIds() =>
      controller.visibleContacts.map((contact) => contact.id).toList();

  setUp(() {
    service = FakeContactsService(contacts: sampleContacts());
    controller = ContactsController(service);
  });

  tearDown(() => controller.dispose());

  group('Загрузка и защита от лишних чтений', () {
    test('Читает адресную книгу ровно 1 раз при инициализации', () async {
      await controller.initialize();
      expect(controller.viewState, ContactsViewState.success);
      expect(service.fetchCalls, 1);
      expect(controller.totalCount, 5);
    });

    test(
      'Поиск и сортировка выполняются в памяти без повторных вызовов сервиса',
      () async {
        await controller.initialize();

        controller.updateQuery('Анна');
        controller.toggleSortOrder();
        controller.updateQuery('');
        controller.toggleSortOrder();

        expect(service.fetchCalls, 1);
      },
    );

    test('Pull-to-refresh явно перезагружает контакты', () async {
      await controller.initialize();
      await controller.refresh();

      expect(service.fetchCalls, 2);
      expect(controller.viewState, ContactsViewState.success);
    });

    test('Пустая адресная книга дает статус emptyBook', () async {
      service.contacts = [];
      await controller.initialize();

      expect(controller.viewState, ContactsViewState.emptyBook);
    });
  });

  group('Поиск и сортировка', () {
    setUp(() => controller.initialize());

    test('Прямая сортировка оставляет безымянные контакты в конце', () {
      expect(visibleIds(), ['3', '1', '2', '4', '5']);
    });

    test('Обратная сортировка также держит безымянные контакты в конце', () {
      controller.toggleSortOrder();
      expect(controller.sortOrder, SortOrder.descending);
      expect(visibleIds(), ['4', '2', '1', '3', '5']);
    });

    test('Поиск регистронезависим и находит по подстроке', () {
      controller.updateQuery('яков');
      expect(visibleIds(), ['4']);

      controller.updateQuery('АЛИСА');
      expect(visibleIds(), ['3']);
    });

    test('Если ничего не найдено — статус emptySearch', () {
      controller.updateQuery('несуществующий контакт');
      expect(controller.viewState, ContactsViewState.emptySearch);
      expect(controller.visibleContacts, isEmpty);
    });
  });

  group('Управление разрешениями', () {
    test('Отказ в разрешении переводит в permissionDenied', () async {
      service.permissionStatus = ContactsPermission.denied;
      service.requestResult = ContactsPermission.denied;

      await controller.initialize();
      expect(controller.viewState, ContactsViewState.permissionDenied);
      expect(service.fetchCalls, 0);
    });

    test(
      'Возврат из настроек с выданным доступом подгружает контакты',
      () async {
        service.permissionStatus = ContactsPermission.denied;
        service.requestResult = ContactsPermission.denied;
        await controller.initialize();

        service.permissionStatus = ContactsPermission.granted;
        await controller.handleAppResumed();

        expect(controller.viewState, ContactsViewState.success);
        expect(service.fetchCalls, 1);
      },
    );
  });
}
