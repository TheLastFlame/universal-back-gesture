import 'package:flutter/material.dart';

enum GestureMeasurementType { pixels, percentage }

class GestureMeasurement {
  final double value;
  final GestureMeasurementType type;

  const GestureMeasurement.pixels(this.value)
      : type = GestureMeasurementType.pixels;

  const GestureMeasurement.percentage(this.value)
      : assert(
          value >= 0.0 && value <= 1.0,
          'Percentage value must be between 0.0 and 1.0',
        ),
        type = GestureMeasurementType.percentage;

  /// Resolves the value to absolute pixels.
  /// For [GestureMeasurementType.percentage], it's relative to the screen width.
  double resolve(BuildContext context) {
    return switch (type) {
      GestureMeasurementType.pixels => value,
      GestureMeasurementType.percentage =>
        MediaQuery.of(context).size.width * value,
    };
  }
}

class BackGestureConfig {
  /// Defines the width of the area on the screen edge where the back gesture can be initiated.
  /// Can be specified in pixels or as a percentage of the screen width.
  final GestureMeasurement swipeDetectionArea;

  /// Defines the swipe distance (horizontally) required for the page transition animation
  /// to go from its start (fully visible) to its end (fully hidden).
  /// This controls the sensitivity of the drag.
  final GestureMeasurement swipeTransitionRange;

  /// Defines the minimum swipe velocity (in dp/s) required to trigger a full pop of the current route.
  final double swipeVelocityThreshold;

  /// Defines the animation progress (0.0 to 1.0) at which the back gesture
  /// will complete and pop the current route, even if swipe velocity is low.
  final double animationProgressCompleteThreshold;

  /// The curve to use for the commit animation when the gesture is completed.
  final Curve commitAnimationCurve;

  /// The duration of the commit animation.
  /// If null, the reverseDuration of the route's transition will be used.
  final Duration? commitAnimationDuration;

  /// Defines the curve to use for the cancel animation when the gesture is cancelled.
  final Curve cancelAnimationCurve;

  /// The duration of the cancel animation.
  /// If null, [commitAnimationDuration] will be used.
  final Duration? cancelAnimationDuration;

  /// Creates a configuration for the back gesture.
  ///
  /// [swipeDetectionArea] defines the width of the area on the screen edge
  /// where the back gesture can be initiated.
  /// [swipeTransitionRange] defines the swipe distance required to trigger
  /// a full pop of the current route.
  /// [swipeVelocityThreshold] defines the minimum swipe velocity required to
  /// trigger a full pop of the current route.
  /// [animationProgressCompleteThreshold] defines the animation progress at
  /// which the back gesture will complete and pop the current route.
  /// [commitAnimationCurve] is the curve to use for the commit animation.
  /// [commitAnimationDuration] is the duration of the commit animation.
  /// [cancelAnimationCurve] is the curve to use for the cancel animation.
  /// [cancelAnimationDuration] is the duration of the cancel animation.
  const BackGestureConfig({
    this.swipeDetectionArea = const GestureMeasurement.percentage(1),
    this.swipeTransitionRange = const GestureMeasurement.pixels(150),
    this.swipeVelocityThreshold = 1100,
    this.animationProgressCompleteThreshold = 0.5,
    this.commitAnimationCurve = Curves.fastEaseInToSlowEaseOut,
    this.commitAnimationDuration,
    this.cancelAnimationCurve = Curves.fastOutSlowIn,
    this.cancelAnimationDuration,
  }) : assert(
          animationProgressCompleteThreshold >= 0.0 &&
              animationProgressCompleteThreshold <= 1.0,
          'Animation progress complete threshold must be between 0.0 and 1.0',
        );
}
