enum ContactFieldLabel { mobile, home, work, main, fax, pager, other, custom }

class LabeledValue {
  final String value;
  final ContactFieldLabel label;
  final String customLabel;

  const LabeledValue({
    required this.value,
    required this.label,
    this.customLabel = '',
  });
}

class ContactOrganization {
  final String company;
  final String jobTitle;
  final String department;

  const ContactOrganization({
    this.company = '',
    this.jobTitle = '',
    this.department = '',
  });

  bool get isEmpty => company.isEmpty && jobTitle.isEmpty && department.isEmpty;
}

class ContactEntry {
  final String id;
  final String displayName;
  final List<LabeledValue> phones;
  final List<LabeledValue> emails;
  final List<LabeledValue> addresses;
  final List<ContactOrganization> organizations;

  ContactEntry({
    required this.id,
    required this.displayName,
    this.phones = const [],
    this.emails = const [],
    this.addresses = const [],
    this.organizations = const [],
  });

  bool get hasName => displayName.trim().isNotEmpty;
  bool get hasEmail => emails.isNotEmpty;

  String? get primaryPhone => phones.isEmpty ? null : phones.first.value;

  bool get hasDetails =>
      phones.isNotEmpty ||
      emails.isNotEmpty ||
      addresses.isNotEmpty ||
      organizations.isNotEmpty;

  String get initials {
    final words = displayName.trim().split(RegExp(r'\s+'));
    if (words.isEmpty || words.first.isEmpty) return '';
    if (words.length == 1) return words.first[0].toUpperCase();
    return (words[0][0] + words[1][0]).toUpperCase();
  }
}
