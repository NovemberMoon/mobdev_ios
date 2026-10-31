import 'dart:math' as math;

import 'package:flutter/material.dart';

class StatusView extends StatelessWidget {
  const StatusView({
    super.key,
    required this.title,
    this.icon,
    this.message,
    this.action,
    this.busy = false,
  });

  final String title;
  final IconData? icon;
  final String? message;
  final Widget? action;
  final bool busy;

  static const double _padding = 24;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(_padding),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: math.max(0.0, constraints.maxHeight - _padding * 2),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (busy)
                    const CircularProgressIndicator()
                  else if (icon != null)
                    Icon(icon, size: 56, color: theme.colorScheme.primary),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium,
                  ),
                  if (message != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      message!,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  if (action != null) ...[
                    const SizedBox(height: 20),
                    action!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
