import 'dart:async';

import 'package:flutter/material.dart';

import '../controllers/contacts_controller.dart';
import '../controllers/theme_controller.dart';
import '../l10n/l10n.dart';
import '../models/contact_entry.dart';
import '../models/contacts_view_state.dart';
import '../widgets/contact_card.dart';
import '../widgets/contacts_search_bar.dart';
import '../widgets/sort_counter_bar.dart';
import '../widgets/status_view.dart';
import 'contact_detail_screen.dart';

class ContactsListScreen extends StatefulWidget {
  const ContactsListScreen({
    super.key,
    required this.controller,
    required this.themeController,
  });

  final ContactsController controller;
  final ThemeController themeController;

  @override
  State<ContactsListScreen> createState() => _ContactsListScreenState();
}

class _ContactsListScreenState extends State<ContactsListScreen> {
  late final TextEditingController _searchController = TextEditingController(
    text: widget.controller.query,
  );
  late final AppLifecycleListener _lifecycleListener;

  ContactsController get _contacts => widget.controller;

  @override
  void initState() {
    super.initState();
    _lifecycleListener = AppLifecycleListener(
      onResume: () => unawaited(_contacts.handleAppResumed()),
    );
    unawaited(_contacts.initialize());
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    _contacts.updateQuery('');
  }

  void _openDetails(ContactEntry contact) {
    FocusManager.instance.primaryFocus?.unfocus();
    unawaited(
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ContactDetailScreen(contact: contact),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.appTitle),
        toolbarHeight: isLandscape ? 48 : null,
        actions: [_ThemeToggleButton(controller: widget.themeController)],
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _contacts,
          builder: (context, _) {
            final state = _contacts.viewState;
            return Column(
              children: [
                if (state.showsListControls)
                  _ListControls(
                    compact: isLandscape,
                    searchController: _searchController,
                    onQueryChanged: _contacts.updateQuery,
                    onQueryCleared: _clearSearch,
                    count: _contacts.visibleContacts.length,
                    sortOrder: _contacts.sortOrder,
                    onToggleSort: _contacts.toggleSortOrder,
                  ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _contacts.refresh,
                    child: _buildBody(context, state),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ContactsViewState state) {
    final l10n = context.l10n;
    return switch (state) {
      ContactsViewState.loading => StatusView(
        busy: true,
        title: l10n.loadingContacts,
      ),
      ContactsViewState.permissionDenied => StatusView(
        icon: Icons.lock_outline,
        title: l10n.permissionDeniedTitle,
        message: l10n.permissionDeniedMessage,
        action: FilledButton.icon(
          onPressed: () => unawaited(_contacts.requestAccess()),
          icon: const Icon(Icons.how_to_reg_outlined),
          label: Text(l10n.requestAccess),
        ),
      ),
      ContactsViewState.permissionPermanentlyDenied => StatusView(
        icon: Icons.settings_outlined,
        title: l10n.permissionPermanentlyDeniedTitle,
        message: l10n.permissionPermanentlyDeniedMessage,
        action: FilledButton.icon(
          onPressed: () => unawaited(_contacts.openSettings()),
          icon: const Icon(Icons.open_in_new),
          label: Text(l10n.openSettings),
        ),
      ),
      ContactsViewState.emptyBook => StatusView(
        icon: Icons.contacts_outlined,
        title: l10n.emptyBookTitle,
        message: l10n.emptyBookMessage,
      ),
      ContactsViewState.emptySearch => StatusView(
        icon: Icons.search_off,
        title: l10n.emptySearchTitle,
        message: l10n.emptySearchMessage(_contacts.query.trim()),
      ),
      ContactsViewState.error => StatusView(
        icon: Icons.error_outline,
        title: l10n.errorTitle,
        message: l10n.errorMessage,
        action: FilledButton.icon(
          onPressed: () => unawaited(_contacts.retry()),
          icon: const Icon(Icons.refresh),
          label: Text(l10n.retry),
        ),
      ),
      ContactsViewState.success => _ContactsList(
        contacts: _contacts.visibleContacts,
        onContactTap: _openDetails,
      ),
    };
  }
}

class _ContactsList extends StatelessWidget {
  const _ContactsList({required this.contacts, required this.onContactTap});

  final List<ContactEntry> contacts;
  final ValueChanged<ContactEntry> onContactTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.only(top: 4, bottom: 16),
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
        return ContactCard(
          key: ValueKey(contact.id),
          contact: contact,
          onTap: () => onContactTap(contact),
        );
      },
    );
  }
}

class _ListControls extends StatelessWidget {
  const _ListControls({
    required this.compact,
    required this.searchController,
    required this.onQueryChanged,
    required this.onQueryCleared,
    required this.count,
    required this.sortOrder,
    required this.onToggleSort,
  });

  final bool compact;
  final TextEditingController searchController;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onQueryCleared;
  final int count;
  final SortOrder sortOrder;
  final VoidCallback onToggleSort;

  @override
  Widget build(BuildContext context) {
    final searchBar = ContactsSearchBar(
      controller: searchController,
      onChanged: onQueryChanged,
      onCleared: onQueryCleared,
      compact: compact,
    );
    final sortBar = SortCounterBar(
      count: count,
      sortOrder: sortOrder,
      onToggleSort: onToggleSort,
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(12, compact ? 4 : 8, 12, compact ? 4 : 8),
      child: compact
          ? Row(
              children: [
                Expanded(flex: 3, child: searchBar),
                const SizedBox(width: 12),
                Expanded(flex: 2, child: sortBar),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [searchBar, const SizedBox(height: 8), sortBar],
            ),
    );
  }
}

class _ThemeToggleButton extends StatelessWidget {
  const _ThemeToggleButton({required this.controller});

  final ThemeController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    return IconButton(
      tooltip: isDark ? l10n.switchToLightTheme : l10n.switchToDarkTheme,
      icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
      onPressed: () => controller.toggle(brightness),
    );
  }
}
