// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Contacts';

  @override
  String get searchHint => 'Search by name';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get sortAscending => 'A–Z';

  @override
  String get sortDescending => 'Z–A';

  @override
  String get toggleSortTooltip => 'Change sort order';

  @override
  String foundCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count contacts',
      one: '$count contact',
    );
    return 'Found: $_temp0';
  }

  @override
  String get noPhone => 'No number';

  @override
  String get hasEmail => 'Has email';

  @override
  String get unnamedContact => 'No name';

  @override
  String get loadingContacts => 'Loading contacts…';

  @override
  String get permissionDeniedTitle => 'No access to contacts';

  @override
  String get permissionDeniedMessage =>
      'Allow the app to read contacts to see the list.';

  @override
  String get requestAccess => 'Request access';

  @override
  String get permissionPermanentlyDeniedTitle => 'Access denied';

  @override
  String get permissionPermanentlyDeniedMessage =>
      'The system prompt is no longer available. Enable contacts access in the app settings and come back.';

  @override
  String get openSettings => 'Open app settings';

  @override
  String get emptyBookTitle => 'No saved contacts';

  @override
  String get emptyBookMessage =>
      'The address book is empty. Add contacts and pull down to refresh.';

  @override
  String get emptySearchTitle => 'Nothing found';

  @override
  String emptySearchMessage(String query) {
    return 'Nothing found for “$query”';
  }

  @override
  String get errorTitle => 'Couldn\'t read contacts';

  @override
  String get errorMessage =>
      'A system error occurred while reading the address book. Please try again.';

  @override
  String get retry => 'Retry';

  @override
  String get switchToLightTheme => 'Light theme';

  @override
  String get switchToDarkTheme => 'Dark theme';

  @override
  String get contactDetailsTitle => 'Contact';

  @override
  String get sectionPhones => 'Phones';

  @override
  String get sectionEmails => 'Email';

  @override
  String get sectionOrganization => 'Organization';

  @override
  String get sectionAddresses => 'Addresses';

  @override
  String get labelMobile => 'Mobile';

  @override
  String get labelHome => 'Home';

  @override
  String get labelWork => 'Work';

  @override
  String get labelMain => 'Main';

  @override
  String get labelFax => 'Fax';

  @override
  String get labelPager => 'Pager';

  @override
  String get labelOther => 'Other';

  @override
  String get fieldCompany => 'Company';

  @override
  String get fieldJobTitle => 'Job title';

  @override
  String get fieldDepartment => 'Department';

  @override
  String get noContactDetails => 'No other details for this contact';

  @override
  String get copiedToClipboard => 'Copied to clipboard';
}
