import 'package:flutter/material.dart';

class KTextStyle {
  static TextStyle bodyTextStyle(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: colorScheme.onSurface,
    );
  }

  static Color generalTextStyle(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return colorScheme.onSurface;
  }

  static Color generalColor(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return colorScheme.inversePrimary;
  }
}
