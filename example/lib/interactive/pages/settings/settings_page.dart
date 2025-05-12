import 'package:flutter/material.dart';
import 'package:universal_back_gesture/back_gesture_config.dart';
import 'package:universal_back_gesture/back_gesture_page_transitions_builder.dart';
import 'package:universal_back_gesture_example/interactive/pages/settings/widgets/animation_progress_complete_treshold_control.dart';
import 'package:universal_back_gesture_example/interactive/pages/settings/back_gesture_config_copy_with.dart';
import 'package:universal_back_gesture_example/interactive/pages/settings/widgets/curve_control.dart';
import 'package:universal_back_gesture_example/interactive/pages/settings/widgets/duration_control.dart';
import 'package:universal_back_gesture_example/interactive/pages/settings/widgets/value_input_control.dart';
import 'package:universal_back_gesture_example/interactive/pages/settings/widgets/gesture_measurement_control.dart';
import 'package:universal_back_gesture_example/main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
    required this.title,
    required this.config,
    required this.onConfigUpdate,
  });

  final String title;
  final BackGestureConfig config;
  final Function(BackGestureConfig config) onConfigUpdate;

  static final elementHeight = 56.0;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late BackGestureConfig config = widget.config;

  void onConfigUpdate(BackGestureConfig newConfig) {
    config = newConfig;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final route = ModalRoute.of(context);
    PageTransitionsBuilder builder;

    switch (route) {
      case CustomBackGesturePageRoute():
        builder = route.parentTransitionBuilder;
      case InstantRouteReplacement():
        builder = route.parentTransitionBuilder;
      default:
        builder = const FadeForwardsPageTransitionsBuilder();
    }

    final List<Widget> children = [
      Tooltip(
        message:
            'Defines the swipe distance required for the page transition animation to go from its start (fully visible) to its end (fully hidden). Controls the sensitivity of the drag.',
        waitDuration: const Duration(milliseconds: 500),
        child: GestureMeasurementControl(
          label: 'Swipe Transition Range',
          measurement: config.swipeTransitionRange,
          onMeasurementChanged: (newMeasurement) {
            onConfigUpdate(
              config.copyWith(swipeTransitionRange: newMeasurement),
            );
          },
          defaultPercentage: widget.config.swipeTransitionRange.value,
          defaultPixels: widget.config.swipeTransitionRange.value * width,
          pixelInputLabel: 'Transition Range (dp)',
          pixelStep: 10.0,
        ),
      ),
      Tooltip(
        message:
            'Defines the width of the area on the screen edge where the back gesture can be initiated. Can be specified in pixels or as a percentage of the screen width.',
        waitDuration: const Duration(milliseconds: 500),
        child: GestureMeasurementControl(
          label: 'Swipe Detection Area',
          measurement: config.swipeDetectionArea,
          onMeasurementChanged: (newMeasurement) {
            onConfigUpdate(config.copyWith(swipeDetectionArea: newMeasurement));
          },
          defaultPercentage: widget.config.swipeDetectionArea.value,
          defaultPixels: widget.config.swipeDetectionArea.value * width,
          pixelInputLabel: 'Detection Area (dp)',
          pixelStep: 2.0,
        ),
      ),
      Tooltip(
        message:
            'Defines the minimum swipe velocity (in dp/s) required to trigger a full pop of the current route. If the swipe velocity exceeds this threshold, the route will be popped regardless of the distance swiped.',
        waitDuration: const Duration(milliseconds: 500),
        child: ValueInputControl(
          label: 'Swipe Velocity Threshold (dp/s)',
          value: config.swipeVelocityThreshold,
          onChanged: (newValue) {
            onConfigUpdate(config.copyWith(swipeVelocityThreshold: newValue));
          },
          defaultValueForInput: widget.config.swipeVelocityThreshold,
          step: 100.0,
        ),
      ),
      Tooltip(
        message:
            'Defines the animation progress (0.0 to 1.0) at which the back gesture will complete and pop the current route, even if swipe velocity is low. A lower value makes the back gesture require less movement to trigger.',
        waitDuration: const Duration(milliseconds: 500),
        child: AnimationProgressCompleteTresholdControl(
          config: config,
          onConfigUpdate: onConfigUpdate,
        ),
      ),
      Tooltip(
        message:
            'The curve to use for the commit animation when the gesture is completed. Controls how the animation accelerates and decelerates during the transition out.',
        waitDuration: const Duration(milliseconds: 500),
        child: CurveControl(
          label: 'Commit Animation Curve',
          value: config.commitAnimationCurve,
          onChanged: (curve) {
            onConfigUpdate(config.copyWith(commitAnimationCurve: curve));
          },
        ),
      ),
      Tooltip(
        message:
            'The duration of the commit animation. Controls how long it takes for the page to animate out after the back gesture is completed.',
        waitDuration: const Duration(milliseconds: 500),
        child: DurationControl(
          label: 'Commit Animation Duration',
          value: config.commitAnimationDuration,
          onChanged: (duration) {
            onConfigUpdate(config.copyWith(commitAnimationDuration: duration));
          },
          defaultValueForInput:
              (widget.config.cancelAnimationDuration?.inMilliseconds ??
                      builder.transitionDuration.inMilliseconds)
                  .toDouble(),
          step: 50.0,
        ),
      ),
      Tooltip(
        message:
            'Defines the curve to use for the cancel animation when the gesture is cancelled. Controls how the animation accelerates and decelerates when returning to the initial state.',
        waitDuration: const Duration(milliseconds: 500),
        child: CurveControl(
          label: 'Cancel Animation Curve',
          value: config.cancelAnimationCurve,
          onChanged: (curve) {
            onConfigUpdate(config.copyWith(cancelAnimationCurve: curve));
          },
        ),
      ),
      Tooltip(
        message:
            'The duration of the cancel animation. Controls how long it takes for the page to animate back to its initial position when the back gesture is cancelled.',
        waitDuration: const Duration(milliseconds: 500),
        child: DurationControl(
          label: 'Cancel Animation Duration',
          value: config.cancelAnimationDuration,
          onChanged: (duration) {
            onConfigUpdate(config.copyWith(cancelAnimationDuration: duration));
          },
          defaultValueForInput:
              (widget.config.cancelAnimationDuration?.inMilliseconds ??
                      widget.config.cancelAnimationDuration?.inMilliseconds ??
                      builder.transitionDuration.inMilliseconds)
                  .toDouble(),
          step: 50.0,
        ),
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Tooltip(
          message: 'Reset all settings to their default values',
          child: FilledButton(
            onPressed: () {
              onConfigUpdate(BackGestureConfig());
            },
            child: Text('Reset'),
          ),
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Save'),
        onPressed: () {
          widget.onConfigUpdate(config);
          Navigator.pushReplacement(
            context,
            InstantRouteReplacement(
              builder:
                  (context) => SettingsPage(
                    title: widget.title,
                    config: config,
                    onConfigUpdate: widget.onConfigUpdate,
                  ),
              config: config,
              parentTransitionBuilder: builder,
            ),
          );
        },
        icon: Icon(Icons.save),
      ),
      body: ListView.separated(
        padding:
            EdgeInsets.symmetric(
              horizontal: width > 500 ? (width - 500) / 2 : 16,
            ) +
            EdgeInsets.only(
              top: 16,
              bottom: MediaQuery.viewPaddingOf(context).bottom + 56 + 32,
            ),
        itemCount: children.length,
        separatorBuilder: (context, index) => SizedBox(height: 12),
        itemBuilder: (context, index) => children[index],
      ),
    );
  }
}

class InstantRouteReplacement<T> extends MaterialPageRoute<T> {
  final BackGestureConfig config;

  final PageTransitionsBuilder parentTransitionBuilder;

  InstantRouteReplacement({
    required super.builder,
    required this.config,
    required this.parentTransitionBuilder,
    super.settings,
  });

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
