import 'package:flutter/material.dart';
import 'controllers/contacts_controller.dart';
import 'controllers/theme_controller.dart';
import 'l10n/l10n.dart';
import 'screens/contacts_list_screen.dart';
import 'services/contacts_service.dart';

void main() {
  runApp(const ContactsApp());
}

class ContactsApp extends StatefulWidget {
  final ContactsService? service;

  const ContactsApp({super.key, this.service});

  @override
  State<ContactsApp> createState() => _ContactsAppState();
}

class _ContactsAppState extends State<ContactsApp> {
  late final ContactsController _contactsController = ContactsController(
    widget.service ?? const ContactsService(),
  );
  final ThemeController _themeController = ThemeController();

  @override
  void dispose() {
    _contactsController.dispose();
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeController,
      builder: (context, themeMode, _) => MaterialApp(
        onGenerateTitle: (context) => context.l10n.appTitle,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2E6B5E),
            brightness: Brightness.light,
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2E6B5E),
            brightness: Brightness.dark,
          ),
        ),
        themeMode: themeMode,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ContactsListScreen(
          controller: _contactsController,
          themeController: _themeController,
        ),
      ),
    );
  }
}
