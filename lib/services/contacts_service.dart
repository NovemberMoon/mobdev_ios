import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/contact_entry.dart';

enum ContactsPermission { granted, denied, permanentlyDenied }

class ContactsService {
  const ContactsService();

  Future<ContactsPermission> checkPermission() async {
    final status = await Permission.contacts.status;
    return _mapPermission(status);
  }

  Future<ContactsPermission> requestPermission() async {
    final status = await Permission.contacts.request();
    return _mapPermission(status);
  }

  Future<bool> openSettings() => openAppSettings();

  Future<List<ContactEntry>> fetchContacts() async {
    final contacts = await FlutterContacts.getContacts(
      withProperties: true,
      sorted: false,
    );

    return contacts.map((c) {
      return ContactEntry(
        id: c.id,
        displayName: c.displayName.trim(),
        phones: c.phones
            .where((p) => p.number.trim().isNotEmpty)
            .map(
              (p) => LabeledValue(
                value: p.number.trim(),
                label: _mapPhoneLabel(p.label),
                customLabel: p.customLabel.trim(),
              ),
            )
            .toList(),
        emails: c.emails
            .where((e) => e.address.trim().isNotEmpty)
            .map(
              (e) => LabeledValue(
                value: e.address.trim(),
                label: _mapEmailLabel(e.label),
                customLabel: e.customLabel.trim(),
              ),
            )
            .toList(),
        addresses: c.addresses
            .where((a) => a.address.trim().isNotEmpty)
            .map(
              (a) => LabeledValue(
                value: a.address.trim(),
                label: ContactFieldLabel.other,
                customLabel: a.customLabel.trim(),
              ),
            )
            .toList(),
        organizations: c.organizations
            .map(
              (o) => ContactOrganization(
                company: o.company.trim(),
                jobTitle: o.title.trim(),
                department: o.department.trim(),
              ),
            )
            .where((o) => !o.isEmpty)
            .toList(),
      );
    }).toList();
  }

  ContactsPermission _mapPermission(PermissionStatus status) {
    if (status.isGranted || status.isLimited) {
      return ContactsPermission.granted;
    }
    if (status.isPermanentlyDenied || status.isRestricted) {
      return ContactsPermission.permanentlyDenied;
    }
    return ContactsPermission.denied;
  }

  ContactFieldLabel _mapPhoneLabel(PhoneLabel label) {
    switch (label) {
      case PhoneLabel.mobile:
        return ContactFieldLabel.mobile;
      case PhoneLabel.work:
        return ContactFieldLabel.work;
      case PhoneLabel.home:
        return ContactFieldLabel.home;
      default:
        return ContactFieldLabel.other;
    }
  }

  ContactFieldLabel _mapEmailLabel(EmailLabel label) {
    switch (label) {
      case EmailLabel.work:
        return ContactFieldLabel.work;
      case EmailLabel.home:
        return ContactFieldLabel.home;
      default:
        return ContactFieldLabel.other;
    }
  }
}
