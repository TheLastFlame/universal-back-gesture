import 'package:flutter/material.dart';
import 'package:universal_back_gesture/back_gesture_config.dart';

extension BackGestureConfigCopyWith on BackGestureConfig {
  BackGestureConfig copyWith({
    GestureMeasurement? swipeDetectionArea,
    GestureMeasurement? swipeTransitionRange,
    double? swipeVelocityThreshold,
    double? animationProgressCompleteThreshold,
    Curve? commitAnimationCurve,
    Duration? commitAnimationDuration,
    Curve? cancelAnimationCurve,
    Duration? cancelAnimationDuration,
  }) {
    return BackGestureConfig(
      swipeDetectionArea: swipeDetectionArea ?? this.swipeDetectionArea,
      swipeTransitionRange: swipeTransitionRange ?? this.swipeTransitionRange,
      swipeVelocityThreshold:
          swipeVelocityThreshold ?? this.swipeVelocityThreshold,
      animationProgressCompleteThreshold:
          animationProgressCompleteThreshold ??
          this.animationProgressCompleteThreshold,
      commitAnimationCurve: commitAnimationCurve ?? this.commitAnimationCurve,
      commitAnimationDuration:
          commitAnimationDuration ?? this.commitAnimationDuration,
      cancelAnimationCurve: cancelAnimationCurve ?? this.cancelAnimationCurve,
      cancelAnimationDuration:
          cancelAnimationDuration ?? this.cancelAnimationDuration,
    );
  }
}
