import 'package:flutter/material.dart';

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({
    super.key,
    required this.themeMode,
    required this.onThemeModeUpdate,
  });

  final ThemeMode themeMode;
  final Function(ThemeMode mode) onThemeModeUpdate;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      label: AnimatedSize(
        duration: Durations.short4,
        child: AnimatedSwitcher(
          duration: Durations.short4,
          child: Text(key: ValueKey(themeMode), themeMode.name.capitalize()),
        ),
      ),
      onPressed: () {
        onThemeModeUpdate(
          ThemeMode.values[(themeMode.index + 1) % ThemeMode.values.length],
        );
      },
      icon: Icon(switch (themeMode) {
        ThemeMode.light => Icons.sunny,
        ThemeMode.dark => Icons.nightlight,
        ThemeMode.system => Icons.brightness_auto,
      }),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return "";

    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
