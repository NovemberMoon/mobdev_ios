import 'package:flutter/widgets.dart';

import '../models/contact_entry.dart';
import 'generated/app_localizations.dart';

export 'generated/app_localizations.dart';

extension AppLocalizationsContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

extension LabeledValueLocalization on LabeledValue {
  String localizedLabel(AppLocalizations l10n) => switch (label) {
    ContactFieldLabel.mobile => l10n.labelMobile,
    ContactFieldLabel.home => l10n.labelHome,
    ContactFieldLabel.work => l10n.labelWork,
    ContactFieldLabel.main => l10n.labelMain,
    ContactFieldLabel.fax => l10n.labelFax,
    ContactFieldLabel.pager => l10n.labelPager,
    ContactFieldLabel.other => l10n.labelOther,
    ContactFieldLabel.custom =>
      customLabel.isNotEmpty ? customLabel : l10n.labelOther,
  };
}
