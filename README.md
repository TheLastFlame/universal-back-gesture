# Universal Back Gesture

[![Pub Version](https://img.shields.io/pub/v/universal_back_gesture?label=pub.dev)](https://pub.dev/packages/universal_back_gesture)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

[Русская версия](https://github.com/TheLastFlame/universal-back-gesture/blob/master/README_RU.md)

#### A universal, highly customizable back gesture for any custom page transitions.
Allows customization of the screen area for gesture initiation, swipe distance and velocity required for transition completion, distance for full animation completion, as well as curves and durations for commit and cancel animations.

**Compatible with PopScope.**

## Preview:

![ezgif-217b0f283a5736](https://github.com/user-attachments/assets/ea57b77c-f49c-4281-9ce5-2d9b5976f911)

Online demo: [https://thela.space/universal-back-gesture](https://thela.space/universal-back-gesture)

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

class CustomBackGesturePageRoute<T> extends MaterialPageRoute<T> {
  final BackGestureConfig config;

  final PageTransitionsBuilder parentTransitionBuilder;

  CustomBackGesturePageRoute({
    required super.builder,
    required this.config,
    required this.parentTransitionBuilder,
    super.settings,
  });

  @override
  Duration get transitionDuration => parentTransitionBuilder.transitionDuration;

  @override
  Duration get reverseTransitionDuration =>
      parentTransitionBuilder.reverseTransitionDuration;

  @override
  DelegatedTransitionBuilder? get delegatedTransition =>
      parentTransitionBuilder.delegatedTransition;

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

| Parameter | Description | Type | Default |
| :----------------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------- | :--------------------------------- | :---------------------------------------------- |
| `swipeDetectionArea`                 | The width of the area of the screen edge where the gesture can be initiated. Can be `.pixels(double)` or `.percentage(double)`.            | `GestureMeasurement`               | `GestureMeasurement.percentage(1)` (All width)  | 
| `swipeTransitionRange`               | The horizontal swipe distance required to animate the page transition from the beginning (fully visible) to the end (fully hidden).        | `GestureMeasurement`               | `GestureMeasurement.pixels(150)`                |
| `swipeVelocityThreshold`             | The minimum swipe speed (pixels/second) required to completely close the current route.                                                    | `GestureMeasurement`               | `GestureMeasurement.pixels(1100)`               |
| `animationProgressCompleteThreshold` | The animation progress (from 0.0 to 1.0) at which the back gesture will complete and close the route, even if the swipe speed is low.      | `double`                           | `0.5`                                           |
| `commitAnimationCurve`               | A curve for the confirmation animation (when the gesture successfully closes the page).                                                    | `Curve`                            | `Curves.fastEaseInToSlowEaseOut`                |
| `commitAnimationDuration`            | Duration of the confirmation animation.                                                                                                    | `Duration?`                        | `null` (uses reverseTransitionDuration)         |
| `cancelAnimationCurve`               | A curve for the cancel animation (when the gesture is canceled).                                                                           | `Curve`                            | `Curves.fastOutSlowIn`                          |
| `cancelAnimationDuration`            | Duration of the cancel animation.                                                                                                          | `Duration?`                        | `null`                                          |


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

## Keywords

swipe back, edge swipe, custom transitions, page transitions, interactive pop, pop gesture, customizable gesture, iOS back gesture, Android back gesture, fullscreen back gesture
