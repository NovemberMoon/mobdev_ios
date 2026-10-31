import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../models/contact_entry.dart';
import 'contact_avatar.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({super.key, required this.contact, required this.onTap});

  final ContactEntry contact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final phone = contact.primaryPhone;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: scheme.surfaceContainerLow,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          onTap: onTap,
          leading: ContactAvatar(seed: contact.id, initials: contact.initials),
          title: Text(
            contact.hasName ? contact.displayName : l10n.unnamedContact,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            phone ?? l10n.noPhone,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: phone == null
                ? TextStyle(fontStyle: FontStyle.italic, color: scheme.outline)
                : null,
          ),
          trailing: contact.hasEmail
              ? Tooltip(
                  message: l10n.hasEmail,
                  child: Icon(
                    Icons.alternate_email,
                    color: scheme.primary,
                    semanticLabel: l10n.hasEmail,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
