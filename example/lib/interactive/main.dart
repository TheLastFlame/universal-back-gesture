import 'package:flutter/material.dart';
import 'package:universal_back_gesture/universal_back_gesture.dart';
import 'package:universal_back_gesture_example/interactive/pages/home/home_page.dart';
import 'package:universal_back_gesture_example/interactive/theme.dart';
import 'package:universal_back_gesture_example/interactive/pages/home/transition_type.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Map<TransitionType, BackGestureConfig> configs = {
    for (var type in TransitionType.values)
      type:
          type == TransitionType.cupertino
              ? BackGestureConfig(
                swipeTransitionRange: GestureMeasurement.percentage(1),
                commitAnimationDuration: const Duration(milliseconds: 350),
              )
              : BackGestureConfig(),
  };
  ThemeMode themeMode = ThemeMode.system;

  void updateConfig(TransitionType type, BackGestureConfig newConfig) {
    setState(() {
      configs[type] = newConfig;
    });
  }

  void updateThemeMode(ThemeMode newThemeMode) {
    themeMode = newThemeMode;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Universal Back Gesture Demo',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      home: HomePage(
        configs: configs,
        themeMode: themeMode,
        onThemeModeUpdate: updateThemeMode,
        onConfigUpdate: updateConfig,
      ),
    );
  }
}
