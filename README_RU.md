# Universal Back Gesture 

[![Pub Version](https://img.shields.io/pub/v/universal_back_gesture?label=pub.dev)](https://pub.dev/packages/universal_back_gesture)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

[English version](README.md)

#### Универсальный широко настраиваемый жест назад для любых пользовательских переходов между страницами. 
Позволяет кастомизировать область экрана для инициации жеста, дистанцию и скорость свайпа, необходимые для завершения перехода, расстояние для полного завершения анимации, а также кривые и длительности для анимаций подтверждения и отмены жеста.

**Совместим с PopScope.**

## Preview:

![ezgif-217b0f283a5736](https://github.com/user-attachments/assets/4d4d97e0-801c-4445-a03c-64bbd34d4479)

Онлайн демо: [https://thela.space/universal-back-gesture](https://thela.space/universal-back-gesture)

## Установка

Выполните команду 
```
flutter pub add universal_back_gesture
```

## Использование

### 1. Глобальная конфигурация

Еслм вы хотите использовать жест назад на всех экранах приложения:

```dart
import 'package:flutter/material.dart';

MaterialApp(
  theme: ThemeData(
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        for (final platform in TargetPlatform.values)
          platform: BackGesturePageTransitionsBuilder(
            // Любой transitionBuilder, который вы хотите использовать
            parentTransitionBuilder: const FadeForwardsPageTransitionsBuilder(),
            config: BackGestureConfig(),
          ),
      },
    ),
  ),
);
```
**Это также переопределяет анимацию для MaterialPage, используемым GoRouter по умолчанию.**

### 2. Конфигурация для отдельных маршрутов

Если вам нужно применить жест "назад" только к определенным маршрутам или использовать разные конфигурации для разных маршрутов, вы можете создать собственный `PageRoute`, который использует `BackGesturePageTransitionsBuilder`.

Сначала создайте собственный `PageRoute`:

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

Затем используйте его при навигации:

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

**Использование с GoRouter:**

Для интеграции с `GoRouter` и применения `universal_back_gesture` к определенным маршрутам, вы можете создать собственный класс, наследуемый от `Page`, который будет использовать ваш `CustomRouteWithBackGesture`.

Сначала убедитесь, что `CustomRouteWithBackGesture` определен, как показано в предыдущем разделе. Затем создайте следующий класс `Page`:

```dart
import 'package:flutter/material.dart';
import 'package:universal_back_gesture/universal_back_gesture.dart';

class MyCustomGoRouterPage<T> extends Page<T> {
  const MyCustomGoRouterPage({
    required this.child,
    // Любой transitionBuilder, который вы хотите использовать
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

Затем используйте `MyCustomGoRouterPage` в конфигурации ваших маршрутов `GoRouter`:

```dart
GoRoute(
    path: '/detail',
    pageBuilder: (BuildContext context, GoRouterState state) {
        return MyCustomGoRouterPage<void>(child: const DetailPage());
    },
),
```

## Конфигурация (`BackGestureConfig`)

Класс `BackGestureConfig` позволяет точно настроить поведение жеста назад:

| Параметр                           | Тип                                | По умолчанию                                     | Описание                                                                                                                                    |
| :--------------------------------- | :--------------------------------- | :--------------------------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------- |
| `swipeDetectionArea`               | `GestureMeasurement`               | `GestureMeasurement.percentage(1)` (Вся ширина) | Ширина области края экрана, где может быть инициирован жест. Может быть `.pixels(double)` или `.percentage(double)`.                        |
| `swipeTransitionRange`             | `GestureMeasurement`               | `GestureMeasurement.percentage(0.4)` (40% ширины) | Горизонтальное расстояние смахивания, необходимое для анимации перехода страницы от начала (полностью видима) до конца (полностью скрыта). |
| `swipeVelocityThreshold`           | `GestureMeasurement`               | `GestureMeasurement.pixels(1100)`              | Минимальная скорость смахивания (пикселей/секунду), необходимая для полного закрытия текущего маршрута. Может быть `.pixels(double)` или `.percentage(double)`. |
| `animationProgressCompleteThreshold` | `double`                           | `0.5`                                          | Прогресс анимации (от 0.0 до 1.0), при котором жест "назад" завершится и закроет маршрут, даже если скорость смахивания низкая.             |
| `commitAnimationCurve`             | `Curve`                            | `Curves.fastEaseInToSlowEaseOut`               | Кривая для анимации подтверждения (когда жест успешно закрывает страницу).                                                               |
| `commitAnimationDuration`          | `Duration?`                        | `null` (использует длительность перехода маршрута) | Длительность анимации подтверждения.                                                                                                      |
| `cancelAnimationCurve`             | `Curve`                            | `Curves.fastOutSlowIn`                         | Кривая для анимации отмены (когда жест отменяется).                                                                                     |
| `cancelAnimationDuration`          | `Duration?`                        | `null` (использует `commitAnimationDuration`)  | Длительность анимации отмены.                                                                                                             |

### `GestureMeasurement`

Этот вспомогательный класс позволяет определять размеры двумя способами:
*   `GestureMeasurement.pixels(double value)`: Указывает абсолютное значение в логических пикселях.
*   `GestureMeasurement.percentage(double value)`: Указывает значение в процентах от ширины экрана (от 0.0 до 1.0).

Пример:
```dart
const BackGestureConfig(
  swipeDetectionArea: GestureMeasurement.pixels(30), // 30 логических пикселей от края
  swipeTransitionRange: GestureMeasurement.percentage(0.5), // 50% ширины экрана для завершения перехода
)
```

## Лицензия

Этот проект лицензирован на условиях лицензии MIT - см. файл [LICENSE](LICENSE) для подробностей.

## Keywords

swipe back, edge swipe, custom transitions, page transitions, interactive pop, pop gesture, customizable gesture, iOS back gesture, Android back gesture, fullscreen back gesture
