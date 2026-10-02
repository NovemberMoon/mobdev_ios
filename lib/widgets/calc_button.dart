import 'package:flutter/material.dart';

enum ButtonType { number, operator, action, accent }

class CalcButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final ButtonType type;
  final int flex;

  const CalcButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = ButtonType.number,
    this.flex = 1,
  });

  Color _getBackgroundColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (type) {
      case ButtonType.number:
        return isDark ? const Color(0xFF2A2D37) : const Color(0xFFE5E9F0);
      case ButtonType.operator:
        return isDark ? const Color(0xFF3B4252) : const Color(0xFFD8DEE9);
      case ButtonType.action:
        return isDark ? const Color(0xFF4C566A) : const Color(0xFFC8D0E0);
      case ButtonType.accent:
        return isDark ? const Color(0xFF88C0D0) : const Color(0xFF5E81AC);
    }
  }

  Color _getTextColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (type == ButtonType.accent) {
      return isDark ? const Color(0xFF2E3440) : Colors.white;
    }
    return isDark ? const Color(0xFFECEFF4) : const Color(0xFF2E3440);
  }

  @override
  Widget build(BuildContext context) {
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final double baseFontSize = isLandscape ? 20.0 : 30.0;
    final double effectiveFontSize = label.length > 2
        ? (isLandscape ? 15.0 : 20.0)
        : (label.length > 1 ? (isLandscape ? 17.0 : 24.0) : baseFontSize);

    return Expanded(
      flex: flex,
      child: Padding(
        padding: EdgeInsets.all(isLandscape ? 1.5 : 3.0),
        child: Material(
          color: _getBackgroundColor(context),
          borderRadius: BorderRadius.circular(isLandscape ? 10 : 16),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            splashColor: Colors.white24,
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: effectiveFontSize,
                  fontWeight: FontWeight.bold,
                  color: _getTextColor(context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
