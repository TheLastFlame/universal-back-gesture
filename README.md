# Universal Back Gesture

[![Pub Version](https://img.shields.io/pub/v/universal_back_gesture?label=pub.dev)](https://pub.dev/packages/universal_back_gesture)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

[Русская версия](README_RU.md)

#### A universal, highly customizable back gesture for any custom page transitions.
Allows customization of the screen area for gesture initiation, swipe distance and velocity required for transition completion, distance for full animation completion, as well as curves and durations for commit and cancel animations.

**Compatible with PopScope.**

## Preview:

![ezgif-157720150ac8c3](https://github.com/user-attachments/assets/7221c5e9-399c-4bda-9f57-f63b8ba7ce1d)

Online demo: [https://thelastflame.github.io/universal-back-gesture](https://thelastflame.github.io/universal-back-gesture)

## Installation

Run the command 
``` 
flutter pub add universal_back_gesture
```

## Usage

### 1. Global Configuration

If you want to use the back gesture on all screens of the application:

```dart
import 'package:flutter/material.dart';

MaterialApp(
  theme: ThemeData(
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        for (final platform in TargetPlatform.values)
          platform: BackGesturePageTransitionsBuilder(
            // Any transitionBuilder you want to use
            parentTransitionBuilder: const FadeForwardsPageTransitionsBuilder(),
            config: BackGestureConfig(),
          ),
      },
    ),
  ),
);
```
**This also overrides the animation for `MaterialPage`, used by GoRouter by default.**

### 2. Configuration for individual routes

If you need to apply the back gesture only to specific routes or use different configurations for different routes, you can create a custom `PageRoute` that uses `BackGesturePageTransitionsBuilder`.

First, create a custom `PageRoute`:

```dart
import 'package:flutter/material.dart';
import 'package:universal_back_gesture/universal_back_gesture.dart';

class CustomRouteWithBackGesture<T> extends MaterialPageRoute<T> {
  CustomRouteWithBackGesture({
    required super.builder,
    super.settings,
    this.parentTransitionBuilder = const CupertinoPageTransitionsBuilder(),
    this.config = const BackGestureConfig(),
  });

  final PageTransitionsBuilder parentTransitionBuilder;
  final BackGestureConfig config;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return BackGesturePageTransitionsBuilder(
      parentTransitionBuilder: parentTransitionBuilder,
      config: config,
    ).buildTransitions<T>(this, context, animation, secondaryAnimation, child);
  }
}
```

Then use it when navigating:

```dart
ElevatedButton(
  onPressed: () {
    Navigator.of(context).push(
      CustomRouteWithBackGesture(
        builder: (context) => const AnotherDetailPage(),
      ),
    );
  },
  child: const Text('Button'),
)
```

**Usage with GoRouter:**

To integrate with `GoRouter` and apply `universal_back_gesture` to specific routes, you can create a custom class inherited from `Page` that will use your `CustomRouteWithBackGesture`.

First, make sure `CustomRouteWithBackGesture` is defined as shown in the previous section. Then create the following `Page` class:

```dart
import 'package:flutter/material.dart';
import 'package:universal_back_gesture/universal_back_gesture.dart';

class MyCustomGoRouterPage<T> extends Page<T> {
  const MyCustomGoRouterPage({
    required this.child,
    // Any transitionBuilder you want to use
    this.parentTransitionBuilder = const FadeForwardsPageTransitionsBuilder(),
    this.config = const BackGestureConfig(),
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  final Widget child;
  final PageTransitionsBuilder parentTransitionBuilder;
  final BackGestureConfig config;

  @override
  Route<T> createRoute(BuildContext context) {
    return CustomRouteWithBackGesture<T>(
      builder: (BuildContext context) => child,
      settings: this,
      parentTransitionBuilder: parentTransitionBuilder,
      config: config,
    );
  }
}
```

Then use `MyCustomGoRouterPage` in your `GoRouter` route configuration:

```dart
GoRoute(
    path: '/detail',
    pageBuilder: (BuildContext context, GoRouterState state) {
        return MyCustomGoRouterPage<void>(child: const DetailPage());
    },
),
```

## Configuration (`BackGestureConfig`)

The `BackGestureConfig` class allows you to fine-tune the behavior of the back gesture:

| Parameter                          | Type                               | Default                                        | Description                                                                                                                               |
| :--------------------------------- | :--------------------------------- | :--------------------------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------- |
| `swipeDetectionArea`               | `GestureMeasurement`               | `GestureMeasurement.percentage(1)` (Full width) | Width of the screen edge area where the gesture can be initiated. Can be `.pixels(double)` or `.percentage(double)`.                     |
| `swipeTransitionRange`             | `GestureMeasurement`               | `GestureMeasurement.percentage(0.4)` (40% width)| Horizontal swipe distance required to animate the page transition from start (fully visible) to end (fully hidden).                   |
| `swipeVelocityThreshold`           | `GestureMeasurement`               | `GestureMeasurement.pixels(1100)`              | Minimum swipe velocity (pixels/second) required to fully close the current route. Can be `.pixels(double)` or `.percentage(double)`.    |
| `animationProgressCompleteThreshold` | `double`                           | `0.5`                                          | Animation progress (from 0.0 to 1.0) at which the back gesture will complete and close the route, even if the swipe velocity is low.        |
| `commitAnimationCurve`             | `Curve`                            | `Curves.fastEaseInToSlowEaseOut`               | Curve for the commit animation (when the gesture successfully closes the page).                                                            |
| `commitAnimationDuration`          | `Duration?`                        | `null` (uses route transition duration)        | Duration of the commit animation.                                                                                                         |
| `cancelAnimationCurve`             | `Curve`                            | `Curves.fastOutSlowIn`                         | Curve for the cancel animation (when the gesture is canceled).                                                                          |
| `cancelAnimationDuration`          | `Duration?`                        | `null` (uses `commitAnimationDuration`)        | Duration of the cancel animation.                                                                                                         |

### `GestureMeasurement`

This helper class allows defining sizes in two ways:
*   `GestureMeasurement.pixels(double value)`: Specifies an absolute value in logical pixels.
*   `GestureMeasurement.percentage(double value)`: Specifies a value as a percentage of the screen width (from 0.0 to 1.0).

Example:
```dart
const BackGestureConfig(
  swipeDetectionArea: GestureMeasurement.pixels(30), // 30 logical pixels from the edge
  swipeTransitionRange: GestureMeasurement.percentage(0.5), // 50% of screen width to complete the transition
)
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
