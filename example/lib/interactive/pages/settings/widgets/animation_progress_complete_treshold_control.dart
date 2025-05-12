import 'package:flutter/material.dart';
import 'package:universal_back_gesture/back_gesture_config.dart';
import 'package:universal_back_gesture_example/interactive/pages/settings/back_gesture_config_copy_with.dart';
import 'package:universal_back_gesture_example/interactive/pages/settings/settings_page.dart';

class AnimationProgressCompleteTresholdControl extends StatelessWidget {
  const AnimationProgressCompleteTresholdControl({
    super.key,
    required this.config,
    required this.onConfigUpdate,
  });

  final BackGestureConfig config;
  final Function(BackGestureConfig config) onConfigUpdate;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SettingsPage.elementHeight,
      child: Row(
        children: [
          Expanded(child: Text('Animation Progress Complete Threshold')),
          const SizedBox(width: 12),
          SizedBox(
            width: 220,
            child: Slider(
              value: config.animationProgressCompleteThreshold,
              divisions: 20,
              label: config.animationProgressCompleteThreshold.toString(),
              onChanged:
                  (value) => onConfigUpdate(
                    config.copyWith(animationProgressCompleteThreshold: value),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
