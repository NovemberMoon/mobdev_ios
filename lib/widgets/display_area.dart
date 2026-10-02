import 'package:flutter/material.dart';

class DisplayArea extends StatelessWidget {
  final String input;
  final String result;
  final String? errorMessage;
  final bool hasMemory;
  final bool isDarkMode;
  final VoidCallback onHistoryPressed;
  final VoidCallback onThemeToggle;

  const DisplayArea({
    super.key,
    required this.input,
    required this.result,
    required this.hasMemory,
    required this.isDarkMode,
    required this.onHistoryPressed,
    required this.onThemeToggle,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    final bool isError = errorMessage != null;
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final theme = Theme.of(context);

    final Color accentColor = isDarkMode
        ? const Color(0xFF88C0D0)
        : const Color(0xFF5E81AC);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: isLandscape ? 6 : 12,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      isDarkMode ? Icons.light_mode : Icons.dark_mode,
                      size: 22,
                    ),
                    onPressed: onThemeToggle,
                    tooltip: isDarkMode ? 'Светлая тема' : 'Темная тема',
                  ),
                  if (hasMemory)
                    Container(
                      margin: const EdgeInsets.only(left: 6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: accentColor, width: 1),
                      ),
                      child: Text(
                        'M',
                        style: TextStyle(
                          color: accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.history, size: 22),
                onPressed: onHistoryPressed,
                tooltip: 'История операций',
              ),
            ],
          ),
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              child: SingleChildScrollView(
                reverse: true,
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    input.isEmpty ? '0' : input,
                    textAlign: TextAlign.right,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: isLandscape ? 22 : 32,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodyLarge?.color,
                      fontFamily: 'monospace',
                      height: 1.25,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: isError
                ? Text(
                    '= $errorMessage',
                    textAlign: TextAlign.right,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: isLandscape ? 16 : 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFBF616A),
                    ),
                  )
                : Text(
                    '= $result',
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: isLandscape ? 20 : 28,
                      fontWeight: FontWeight.w600,
                      color: accentColor,
                      fontFamily: 'monospace',
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
