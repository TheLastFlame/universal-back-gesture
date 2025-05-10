// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:universal_back_gesture/back_gesture_config.dart';

class BackGesturePageTransitionsBuilder extends PageTransitionsBuilder {
  const BackGesturePageTransitionsBuilder({
    required this.parentTransitionBuilder,

    /// Allows you to override the transition animation duration. By default, it uses the duration of the parent transition animation.
    this.transitionDurationOverride,

    /// The gesture configuration.
    this.config = const BackGestureConfig(),
  });

  final Duration? transitionDurationOverride;
  final PageTransitionsBuilder parentTransitionBuilder;

  final BackGestureConfig config;

  @override
  Duration get transitionDuration =>
      transitionDurationOverride ?? parentTransitionBuilder.transitionDuration;

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return _BackGestureWrapper(
      route: route,
      config: config,
      child: parentTransitionBuilder.buildTransitions(
        route,
        context,
        animation,
        secondaryAnimation,
        child,
      ),
    );
  }
}

class _BackGestureWrapper extends StatefulWidget {
  const _BackGestureWrapper({
    required this.route,
    required this.config,
    required this.child,
  });

  final PageRoute route;
  final BackGestureConfig config;

  final Widget child;

  @override
  State<_BackGestureWrapper> createState() => __BackGestureWrapperState();
}

class __BackGestureWrapperState extends State<_BackGestureWrapper> {
  late HorizontalDragGestureRecognizer _recognizer;
  bool _isGestureStarted = false;
  double _gestureStartX = 0.0;

  @override
  void initState() {
    super.initState();
    _recognizer = HorizontalDragGestureRecognizer(debugOwner: this)
      ..onStart = _handleDragStart
      ..onUpdate = _handleDragUpdate
      ..onEnd = _handleDragEnd
      ..onCancel = _handleDragCancel;
  }

  @override
  void dispose() {
    _recognizer.dispose();
    super.dispose();
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (!widget.route.popGestureEnabled || _isGestureStarted) return;

    final double edgeWidth = widget.config.swipeDetectionArea.resolve(context);
    // Check if the pointer event started within the designated swipe area.
    if (event.localPosition.dx <= edgeWidth) {
      _recognizer.addPointer(event);
    }
  }

  void _handleDragStart(DragStartDetails details) {
    _gestureStartX = details.localPosition.dx;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_isGestureStarted) {
      // The gesture is considered started only on a positive delta (drag to the right).
      final delta = details.primaryDelta ?? 0;
      if (delta <= 0) return;

      _isGestureStarted = true;

      final navigator = widget.route.navigator;
      navigator!.didStartUserGesture();
    }

    final controller = widget.route.controller!;

    final swipeThreshold = widget.config.swipeTransitionRange.resolve(context);

    final progress =
        (details.localPosition.dx - _gestureStartX) / swipeThreshold;

    controller.value = 1.0 - progress.clamp(0.0, 1.0);
  }

  void _handleDragEnd(DragEndDetails details) {
    _isGestureStarted = false;
    _processDragEnd(details.velocity.pixelsPerSecond.dx);
  }

  void _handleDragCancel() {
    _isGestureStarted = false;
    _processDragEnd(0.0);
  }

  void _processDragEnd(double velocity) {
    final AnimationController controller = widget.route.controller!;
    final NavigatorState navigator = widget.route.navigator!;

    final double minimumVelocity = widget.config.swipeVelocityThreshold.resolve(
      context,
    );

    final bool commit = velocity.abs() >= minimumVelocity
        // Commit if velocity is positive and exceeds threshold
        ? velocity > 0
        // Commit if dragged past threshold
        : (1 - controller.value) >=
            widget.config.animationProgressCompleteThreshold;

    final Duration routeTransitionDuration = widget.route.transitionDuration;
    final Duration commitAnimationDuration =
        widget.config.commitAnimationDuration ?? routeTransitionDuration;

    if (commit) {
      // Only pop if the route is still the current one.
      if (widget.route.isCurrent) {
        navigator.pop();
      }
      // Animate the controller to the "popped" state.
      controller.animateBack(
        0.0,
        duration: commitAnimationDuration,
        curve: widget.config.commitAnimationCurve,
      );
    } else {
      // Animate the controller back to the "fully visible" state.
      controller.animateTo(
        1.0,
        duration:
            widget.config.cancelAnimationDuration ?? commitAnimationDuration,
        curve: widget.config.cancelAnimationCurve,
      );
    }

    // Add a status listener to call didStopUserGesture when the animation completes.
    if (controller.isAnimating) {
      late AnimationStatusListener animationStatusCallback;
      animationStatusCallback = (AnimationStatus status) {
        navigator.didStopUserGesture();
        controller.removeStatusListener(animationStatusCallback);
      };
      controller.addStatusListener(animationStatusCallback);
    } else if (navigator.userGestureInProgress) {
      navigator.didStopUserGesture();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _handlePointerDown,
      behavior: HitTestBehavior.translucent,
      child: widget.child,
    );
  }
}
