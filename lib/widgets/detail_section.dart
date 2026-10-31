import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DetailSection extends StatelessWidget {
  const DetailSection({super.key, required this.title, required this.tiles});

  final String title;
  final List<Widget> tiles;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
          child: Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        Material(
          color: theme.colorScheme.surfaceContainerLow,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: ListTile.divideTiles(context: context, tiles: tiles).toList(),
          ),
        ),
      ],
    );
  }
}

class CopyableDetailTile extends StatelessWidget {
  const CopyableDetailTile({
    super.key,
    required this.icon,
    required this.value,
    required this.caption,
    required this.copiedMessage,
  });

  final IconData icon;
  final String value;
  final String caption;
  final String copiedMessage;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(value),
      subtitle: Text(caption),
      onTap: () => _copy(context),
    );
  }

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(copiedMessage)));
  }
}
