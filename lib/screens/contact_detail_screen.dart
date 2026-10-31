import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../models/contact_entry.dart';
import '../widgets/contact_avatar.dart';
import '../widgets/detail_section.dart';

class ContactDetailScreen extends StatelessWidget {
  const ContactDetailScreen({super.key, required this.contact});

  final ContactEntry contact;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isLandscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.contactDetailsTitle),
        toolbarHeight: isLandscape ? 48 : null,
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ContactHeader(contact: contact, compact: isLandscape),
                  if (contact.phones.isNotEmpty)
                    DetailSection(
                      title: l10n.sectionPhones,
                      tiles: [
                        for (final phone in contact.phones)
                          CopyableDetailTile(
                            icon: Icons.phone_outlined,
                            value: phone.value,
                            caption: phone.localizedLabel(l10n),
                            copiedMessage: l10n.copiedToClipboard,
                          ),
                      ],
                    ),
                  if (contact.emails.isNotEmpty)
                    DetailSection(
                      title: l10n.sectionEmails,
                      tiles: [
                        for (final email in contact.emails)
                          CopyableDetailTile(
                            icon: Icons.email_outlined,
                            value: email.value,
                            caption: email.localizedLabel(l10n),
                            copiedMessage: l10n.copiedToClipboard,
                          ),
                      ],
                    ),
                  for (final organization in contact.organizations)
                    DetailSection(
                      title: l10n.sectionOrganization,
                      tiles: [
                        if (organization.company.isNotEmpty)
                          CopyableDetailTile(
                            icon: Icons.business_outlined,
                            value: organization.company,
                            caption: l10n.fieldCompany,
                            copiedMessage: l10n.copiedToClipboard,
                          ),
                        if (organization.jobTitle.isNotEmpty)
                          CopyableDetailTile(
                            icon: Icons.badge_outlined,
                            value: organization.jobTitle,
                            caption: l10n.fieldJobTitle,
                            copiedMessage: l10n.copiedToClipboard,
                          ),
                        if (organization.department.isNotEmpty)
                          CopyableDetailTile(
                            icon: Icons.apartment_outlined,
                            value: organization.department,
                            caption: l10n.fieldDepartment,
                            copiedMessage: l10n.copiedToClipboard,
                          ),
                      ],
                    ),
                  if (contact.addresses.isNotEmpty)
                    DetailSection(
                      title: l10n.sectionAddresses,
                      tiles: [
                        for (final address in contact.addresses)
                          CopyableDetailTile(
                            icon: Icons.location_on_outlined,
                            value: address.value,
                            caption: address.localizedLabel(l10n),
                            copiedMessage: l10n.copiedToClipboard,
                          ),
                      ],
                    ),
                  if (!contact.hasDetails)
                    Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: Text(
                        l10n.noContactDetails,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ContactHeader extends StatelessWidget {
  const _ContactHeader({required this.contact, required this.compact});

  final ContactEntry contact;

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final avatar = ContactAvatar(
      seed: contact.id,
      initials: contact.initials,
      radius: compact ? 32 : 48,
    );
    final name = Text(
      contact.hasName ? contact.displayName : l10n.unnamedContact,
      textAlign: compact ? TextAlign.start : TextAlign.center,
      style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
    );

    if (compact) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            avatar,
            const SizedBox(width: 16),
            Expanded(child: name),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(children: [avatar, const SizedBox(height: 16), name]),
    );
  }
}
