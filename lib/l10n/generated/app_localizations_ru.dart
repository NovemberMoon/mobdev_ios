// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Контакты';

  @override
  String get searchHint => 'Поиск по имени';

  @override
  String get clearSearch => 'Очистить поиск';

  @override
  String get sortAscending => 'А–Я';

  @override
  String get sortDescending => 'Я–А';

  @override
  String get toggleSortTooltip => 'Изменить порядок сортировки';

  @override
  String foundCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count контакта',
      many: '$count контактов',
      few: '$count контакта',
      one: '$count контакт',
    );
    return 'Найдено: $_temp0';
  }

  @override
  String get noPhone => 'Без номера';

  @override
  String get hasEmail => 'Есть email';

  @override
  String get unnamedContact => 'Без имени';

  @override
  String get loadingContacts => 'Загрузка контактов…';

  @override
  String get permissionDeniedTitle => 'Нет доступа к контактам';

  @override
  String get permissionDeniedMessage =>
      'Разрешите приложению читать контакты, чтобы увидеть список.';

  @override
  String get requestAccess => 'Запросить доступ';

  @override
  String get permissionPermanentlyDeniedTitle => 'Доступ запрещён';

  @override
  String get permissionPermanentlyDeniedMessage =>
      'Системный запрос больше недоступен. Включите доступ к контактам в настройках приложения и вернитесь сюда.';

  @override
  String get openSettings => 'Открыть настройки приложения';

  @override
  String get emptyBookTitle => 'Нет сохранённых контактов';

  @override
  String get emptyBookMessage =>
      'Адресная книга пуста. Добавьте контакты и потяните экран вниз, чтобы обновить список.';

  @override
  String get emptySearchTitle => 'Ничего не найдено';

  @override
  String emptySearchMessage(String query) {
    return 'Ничего не найдено по запросу «$query»';
  }

  @override
  String get errorTitle => 'Не удалось прочитать контакты';

  @override
  String get errorMessage =>
      'Произошла системная ошибка при чтении адресной книги. Попробуйте ещё раз.';

  @override
  String get retry => 'Повторить';

  @override
  String get switchToLightTheme => 'Светлая тема';

  @override
  String get switchToDarkTheme => 'Тёмная тема';

  @override
  String get contactDetailsTitle => 'Контакт';

  @override
  String get sectionPhones => 'Телефоны';

  @override
  String get sectionEmails => 'Электронная почта';

  @override
  String get sectionOrganization => 'Организация';

  @override
  String get sectionAddresses => 'Адреса';

  @override
  String get labelMobile => 'Мобильный';

  @override
  String get labelHome => 'Домашний';

  @override
  String get labelWork => 'Рабочий';

  @override
  String get labelMain => 'Основной';

  @override
  String get labelFax => 'Факс';

  @override
  String get labelPager => 'Пейджер';

  @override
  String get labelOther => 'Другой';

  @override
  String get fieldCompany => 'Компания';

  @override
  String get fieldJobTitle => 'Должность';

  @override
  String get fieldDepartment => 'Отдел';

  @override
  String get noContactDetails => 'Других данных о контакте нет';

  @override
  String get copiedToClipboard => 'Скопировано в буфер обмена';
}
