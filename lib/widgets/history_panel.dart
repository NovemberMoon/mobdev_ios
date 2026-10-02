import 'package:flutter/material.dart';

import '../models/history_entry.dart';

class HistoryPanel extends StatelessWidget {
  final List<HistoryEntry> history;
  final ValueChanged<String> onSelect;
  final VoidCallback onClear;

  const HistoryPanel({
    super.key,
    required this.history,
    required this.onSelect,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: isDark ? const Color(0xFF242933) : const Color(0xFFECEFF4),
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.history,
                      color: isDark
                          ? const Color(0xFF88C0D0)
                          : const Color(0xFF5E81AC),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'История (до 10)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                ),
                if (history.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.delete_sweep, size: 20),
                    onPressed: onClear,
                    tooltip: 'Очистить историю',
                  ),
              ],
            ),
            const Divider(height: 16),
            Expanded(
              child: history.isEmpty
                  ? const Center(
                      child: Text(
                        'История вычислений пуста',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    )
                  : ListView.separated(
                      itemCount: history.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = history[index];
                        return ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            item.expression,
                            style: TextStyle(
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withValues(alpha: 0.8),
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Text(
                            '= ${item.result}',
                            style: TextStyle(
                              color: isDark
                                  ? const Color(0xFF88C0D0)
                                  : const Color(0xFF5E81AC),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          onTap: () => onSelect(item.expression),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
