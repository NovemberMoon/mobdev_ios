import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ru'),
    Locale('en'),
  ];

  /// Application title shown in the app bar and task switcher.
  ///
  /// In ru, this message translates to:
  /// **'Контакты'**
  String get appTitle;

  /// Placeholder of the contacts search field.
  ///
  /// In ru, this message translates to:
  /// **'Поиск по имени'**
  String get searchHint;

  /// Tooltip of the button that clears the search query.
  ///
  /// In ru, this message translates to:
  /// **'Очистить поиск'**
  String get clearSearch;

  /// Label of the ascending sort mode.
  ///
  /// In ru, this message translates to:
  /// **'А–Я'**
  String get sortAscending;

  /// Label of the descending sort mode.
  ///
  /// In ru, this message translates to:
  /// **'Я–А'**
  String get sortDescending;

  /// Tooltip of the sort toggle button.
  ///
  /// In ru, this message translates to:
  /// **'Изменить порядок сортировки'**
  String get toggleSortTooltip;

  /// Number of contacts matching the current search.
  ///
  /// In ru, this message translates to:
  /// **'Найдено: {count, plural, one{{count} контакт} few{{count} контакта} many{{count} контактов} other{{count} контакта}}'**
  String foundCount(int count);

  /// Shown instead of a phone number when the contact has none.
  ///
  /// In ru, this message translates to:
  /// **'Без номера'**
  String get noPhone;

  /// Tooltip and semantic label of the email presence badge.
  ///
  /// In ru, this message translates to:
  /// **'Есть email'**
  String get hasEmail;

  /// Shown when a contact has no display name.
  ///
  /// In ru, this message translates to:
  /// **'Без имени'**
  String get unnamedContact;

  /// Status while contacts are being read from the device.
  ///
  /// In ru, this message translates to:
  /// **'Загрузка контактов…'**
  String get loadingContacts;

  /// Title of the permission denied state.
  ///
  /// In ru, this message translates to:
  /// **'Нет доступа к контактам'**
  String get permissionDeniedTitle;

  /// Explanation of the permission denied state.
  ///
  /// In ru, this message translates to:
  /// **'Разрешите приложению читать контакты, чтобы увидеть список.'**
  String get permissionDeniedMessage;

  /// Button that shows the system permission dialog again.
  ///
  /// In ru, this message translates to:
  /// **'Запросить доступ'**
  String get requestAccess;

  /// Title of the permanently denied state.
  ///
  /// In ru, this message translates to:
  /// **'Доступ запрещён'**
  String get permissionPermanentlyDeniedTitle;

  /// Explanation of the permanently denied state.
  ///
  /// In ru, this message translates to:
  /// **'Системный запрос больше недоступен. Включите доступ к контактам в настройках приложения и вернитесь сюда.'**
  String get permissionPermanentlyDeniedMessage;

  /// Button that opens the system settings of the app.
  ///
  /// In ru, this message translates to:
  /// **'Открыть настройки приложения'**
  String get openSettings;

  /// Title of the empty address book state.
  ///
  /// In ru, this message translates to:
  /// **'Нет сохранённых контактов'**
  String get emptyBookTitle;

  /// Explanation of the empty address book state.
  ///
  /// In ru, this message translates to:
  /// **'Адресная книга пуста. Добавьте контакты и потяните экран вниз, чтобы обновить список.'**
  String get emptyBookMessage;

  /// Title of the empty search result state.
  ///
  /// In ru, this message translates to:
  /// **'Ничего не найдено'**
  String get emptySearchTitle;

  /// Explanation of the empty search result state.
  ///
  /// In ru, this message translates to:
  /// **'Ничего не найдено по запросу «{query}»'**
  String emptySearchMessage(String query);

  /// Title of the read error state.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось прочитать контакты'**
  String get errorTitle;

  /// Explanation of the read error state.
  ///
  /// In ru, this message translates to:
  /// **'Произошла системная ошибка при чтении адресной книги. Попробуйте ещё раз.'**
  String get errorMessage;

  /// Button that retries reading contacts.
  ///
  /// In ru, this message translates to:
  /// **'Повторить'**
  String get retry;

  /// Tooltip of the theme toggle in dark mode.
  ///
  /// In ru, this message translates to:
  /// **'Светлая тема'**
  String get switchToLightTheme;

  /// Tooltip of the theme toggle in light mode.
  ///
  /// In ru, this message translates to:
  /// **'Тёмная тема'**
  String get switchToDarkTheme;

  /// App bar title of the contact details screen.
  ///
  /// In ru, this message translates to:
  /// **'Контакт'**
  String get contactDetailsTitle;

  /// Header of the phone numbers section.
  ///
  /// In ru, this message translates to:
  /// **'Телефоны'**
  String get sectionPhones;

  /// Header of the email addresses section.
  ///
  /// In ru, this message translates to:
  /// **'Электронная почта'**
  String get sectionEmails;

  /// Header of the organization section.
  ///
  /// In ru, this message translates to:
  /// **'Организация'**
  String get sectionOrganization;

  /// Header of the postal addresses section.
  ///
  /// In ru, this message translates to:
  /// **'Адреса'**
  String get sectionAddresses;

  /// Mobile field label.
  ///
  /// In ru, this message translates to:
  /// **'Мобильный'**
  String get labelMobile;

  /// Home field label.
  ///
  /// In ru, this message translates to:
  /// **'Домашний'**
  String get labelHome;

  /// Work field label.
  ///
  /// In ru, this message translates to:
  /// **'Рабочий'**
  String get labelWork;

  /// Main field label.
  ///
  /// In ru, this message translates to:
  /// **'Основной'**
  String get labelMain;

  /// Fax field label.
  ///
  /// In ru, this message translates to:
  /// **'Факс'**
  String get labelFax;

  /// Pager field label.
  ///
  /// In ru, this message translates to:
  /// **'Пейджер'**
  String get labelPager;

  /// Fallback field label.
  ///
  /// In ru, this message translates to:
  /// **'Другой'**
  String get labelOther;

  /// Company field caption.
  ///
  /// In ru, this message translates to:
  /// **'Компания'**
  String get fieldCompany;

  /// Job title field caption.
  ///
  /// In ru, this message translates to:
  /// **'Должность'**
  String get fieldJobTitle;

  /// Department field caption.
  ///
  /// In ru, this message translates to:
  /// **'Отдел'**
  String get fieldDepartment;

  /// Shown when a contact has only a name.
  ///
  /// In ru, this message translates to:
  /// **'Других данных о контакте нет'**
  String get noContactDetails;

  /// Snackbar after copying a value.
  ///
  /// In ru, this message translates to:
  /// **'Скопировано в буфер обмена'**
  String get copiedToClipboard;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
