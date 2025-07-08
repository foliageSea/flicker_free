import 'package:flutter/material.dart';

class ThemeColorUtil {
  static Color getPrimaryColorWithAlpha(BuildContext context) {
    return Theme.of(context).colorScheme.primary.withValues(alpha: 0.3);
  }

  static Color getPrimaryColor(BuildContext context) {
    return Theme.of(context).colorScheme.primary;
  }

  static Color getTextColor(BuildContext context) {
    return Theme.of(context).colorScheme.onBackground;
  }
}
