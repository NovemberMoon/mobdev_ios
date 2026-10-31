import 'package:flutter/material.dart';

import '../l10n/l10n.dart';

class ContactsSearchBar extends StatelessWidget {
  const ContactsSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onCleared,
    this.compact = false,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onCleared;

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SearchBar(
      controller: controller,
      hintText: l10n.searchHint,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      elevation: const WidgetStatePropertyAll(0),
      constraints: BoxConstraints(minHeight: compact ? 44 : 52),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 12),
      ),
      leading: const Icon(Icons.search),
      trailing: [
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) => value.text.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
                  tooltip: l10n.clearSearch,
                  icon: const Icon(Icons.close),
                  onPressed: onCleared,
                ),
        ),
      ],
    );
  }
}
