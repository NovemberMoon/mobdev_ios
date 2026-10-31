import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../models/contacts_view_state.dart';

class SortCounterBar extends StatelessWidget {
  const SortCounterBar({
    super.key,
    required this.count,
    required this.sortOrder,
    required this.onToggleSort,
  });

  final int count;
  final SortOrder sortOrder;
  final VoidCallback onToggleSort;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isAscending = sortOrder == SortOrder.ascending;

    return Row(
      children: [
        Expanded(
          child: Text(
            l10n.foundCount(count),
            style: Theme.of(context).textTheme.labelLarge,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Tooltip(
          message: l10n.toggleSortTooltip,
          child: FilledButton.tonalIcon(
            onPressed: onToggleSort,
            icon: Icon(isAscending ? Icons.arrow_downward : Icons.arrow_upward),
            label: Text(isAscending ? l10n.sortAscending : l10n.sortDescending),
          ),
        ),
      ],
    );
  }
}
