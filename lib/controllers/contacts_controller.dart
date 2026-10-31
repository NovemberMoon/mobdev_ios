import 'package:flutter/foundation.dart';
import '../models/contact_entry.dart';
import '../models/contacts_view_state.dart';
import '../services/contacts_service.dart';

class ContactsController extends ChangeNotifier {
  final ContactsService _service;

  ContactsController([ContactsService? service])
    : _service = service ?? const ContactsService();

  ContactsViewState _state = ContactsViewState.loading;
  List<ContactEntry> _allContacts = [];
  String _query = '';
  SortOrder _sortOrder = SortOrder.ascending;

  ContactsViewState get viewState {
    if (_state == ContactsViewState.success) {
      if (_allContacts.isEmpty) return ContactsViewState.emptyBook;
      if (visibleContacts.isEmpty) return ContactsViewState.emptySearch;
    }
    return _state;
  }

  String get query => _query;
  SortOrder get sortOrder => _sortOrder;
  int get totalCount => _allContacts.length;

  List<ContactEntry> get visibleContacts {
    var result = List<ContactEntry>.from(_allContacts);

    if (_query.trim().isNotEmpty) {
      final needle = _query.trim().toLowerCase().replaceAll('ё', 'е');
      result = result.where((c) {
        final name = c.displayName.toLowerCase().replaceAll('ё', 'е');
        return name.contains(needle);
      }).toList();
    }

    result.sort((a, b) {
      if (!a.hasName && b.hasName) return 1;
      if (a.hasName && !b.hasName) return -1;

      final cmp = a.displayName.toLowerCase().compareTo(
        b.displayName.toLowerCase(),
      );
      return _sortOrder == SortOrder.ascending ? cmp : -cmp;
    });

    return result;
  }

  Future<void> initialize() async {
    await requestAccess();
  }

  Future<void> requestAccess() async {
    _state = ContactsViewState.loading;
    notifyListeners();

    try {
      var permission = await _service.checkPermission();
      if (permission != ContactsPermission.granted) {
        permission = await _service.requestPermission();
      }

      if (permission == ContactsPermission.granted) {
        _allContacts = await _service.fetchContacts();
        _state = ContactsViewState.success;
      } else if (permission == ContactsPermission.permanentlyDenied) {
        _state = ContactsViewState.permissionPermanentlyDenied;
      } else {
        _state = ContactsViewState.permissionDenied;
      }
    } catch (_) {
      _state = ContactsViewState.error;
    }

    notifyListeners();
  }

  Future<void> refresh() async {
    try {
      final permission = await _service.checkPermission();
      if (permission == ContactsPermission.granted) {
        _allContacts = await _service.fetchContacts();
        _state = ContactsViewState.success;
      }
    } catch (_) {
      _state = ContactsViewState.error;
    }
    notifyListeners();
  }

  Future<void> handleAppResumed() async {
    if (_state == ContactsViewState.permissionDenied ||
        _state == ContactsViewState.permissionPermanentlyDenied) {
      final permission = await _service.checkPermission();
      if (permission == ContactsPermission.granted) {
        await refresh();
      }
    }
  }

  void updateQuery(String newQuery) {
    _query = newQuery;
    notifyListeners();
  }

  void toggleSortOrder() {
    _sortOrder = _sortOrder.toggled;
    notifyListeners();
  }

  Future<void> openSettings() => _service.openSettings();
  Future<void> retry() => requestAccess();
}
