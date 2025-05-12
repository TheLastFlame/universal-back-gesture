import 'package:flutter/material.dart';
import 'package:universal_back_gesture/universal_back_gesture.dart';
import 'package:universal_back_gesture_example/interactive/pages/home/theme_switcher.dart';
import 'package:universal_back_gesture_example/interactive/pages/home/transition_type.dart';
import 'package:universal_back_gesture_example/interactive/pages/settings/settings_page.dart';
import 'package:universal_back_gesture_example/main.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.configs,
    required this.themeMode,
    required this.onThemeModeUpdate,
    required this.onConfigUpdate,
  });

  final Map<TransitionType, BackGestureConfig> configs;
  final ThemeMode themeMode;
  final Function(ThemeMode themeMode) onThemeModeUpdate;
  final Function(TransitionType type, BackGestureConfig config) onConfigUpdate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Back Gesture Demo'),
        actionsPadding: EdgeInsets.only(right: 16),
        actions: [
          ThemeSwitcher(
            themeMode: themeMode,
            onThemeModeUpdate: onThemeModeUpdate,
          ),
        ],
      ),
      body: Center(
        child: Column(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (final type in TransitionType.values)
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    CustomBackGesturePageRoute(
                      config: configs[type]!,
                      parentTransitionBuilder: type.builder,
                      builder:
                          (context) => SettingsPage(
                            title: type.name,
                            config: configs[type]!,
                            onConfigUpdate:
                                (newConfig) => onConfigUpdate(type, newConfig),
                          ),
                    ),
                  );
                },
                child: Text(type.name),
              ),
          ],
        ),
      ),
    );
  }
}
