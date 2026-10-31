import 'package:contacts_app/models/contact_entry.dart';
import 'package:contacts_app/services/contacts_service.dart';

class FakeContactsService extends ContactsService {
  List<ContactEntry> contacts;
  ContactsPermission permissionStatus;
  ContactsPermission requestResult;
  bool failFetch;

  int fetchCalls = 0;
  int requestCalls = 0;
  int settingsCalls = 0;

  FakeContactsService({
    this.contacts = const [],
    this.permissionStatus = ContactsPermission.granted,
    ContactsPermission? requestResult,
    this.failFetch = false,
  }) : requestResult = requestResult ?? permissionStatus;

  @override
  Future<ContactsPermission> checkPermission() async => permissionStatus;

  @override
  Future<ContactsPermission> requestPermission() async {
    requestCalls++;
    permissionStatus = requestResult;
    return permissionStatus;
  }

  @override
  Future<List<ContactEntry>> fetchContacts() async {
    fetchCalls++;
    if (failFetch) throw Exception('Ошибка чтения контактов');
    return contacts;
  }

  @override
  Future<bool> openSettings() async {
    settingsCalls++;
    return true;
  }
}

List<ContactEntry> sampleContacts() => [
  ContactEntry(
    id: '1',
    displayName: 'Анна Иванова',
    phones: const [
      LabeledValue(value: '+7 900 000-00-01', label: ContactFieldLabel.mobile),
      LabeledValue(value: '+7 495 000-00-02', label: ContactFieldLabel.work),
    ],
    emails: const [
      LabeledValue(value: 'anna@example.org', label: ContactFieldLabel.work),
    ],
    organizations: const [
      ContactOrganization(company: 'ООО Ромашка', jobTitle: 'Менеджер'),
    ],
  ),
  ContactEntry(
    id: '2',
    displayName: 'Борис Петров',
    phones: const [
      LabeledValue(value: '+7 900 000-00-03', label: ContactFieldLabel.home),
    ],
  ),
  ContactEntry(id: '3', displayName: 'Алиса Смирнова'),
  ContactEntry(id: '4', displayName: 'Яков Васильев'),
  ContactEntry(
    id: '5',
    displayName: '',
    phones: const [
      LabeledValue(value: '+7 900 000-00-05', label: ContactFieldLabel.other),
    ],
  ),
];
