import 'package:flutter/material.dart';

class ContactAvatar extends StatelessWidget {
  final String seed;
  final String initials;
  final double radius;

  const ContactAvatar({
    super.key,
    required this.seed,
    required this.initials,
    this.radius = 22,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final palette = [
      (scheme.primaryContainer, scheme.onPrimaryContainer),
      (scheme.secondaryContainer, scheme.onSecondaryContainer),
      (scheme.tertiaryContainer, scheme.onTertiaryContainer),
    ];

    final colorIndex = seed.hashCode.abs() % palette.length;
    final (background, foreground) = palette[colorIndex];

    return CircleAvatar(
      radius: radius,
      backgroundColor: background,
      foregroundColor: foreground,
      child: initials.isEmpty
          ? Icon(Icons.person_outline, size: radius)
          : Text(
              initials,
              style: TextStyle(
                fontSize: radius * 0.75,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
