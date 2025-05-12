import 'package:flutter/material.dart';
import 'package:universal_back_gesture_example/interactive/pages/settings/widgets/value_input_control.dart';

class DurationControl extends StatelessWidget {
  const DurationControl({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.step = 10.0,
    this.defaultValueForInput = 800.0,
  });

  final String label;
  final Duration? value;
  final ValueChanged<Duration?> onChanged;
  final double step;
  final double defaultValueForInput;

  @override
  Widget build(BuildContext context) {
    return ValueInputControl(
      label: '$label (ms)',
      value: value?.inMilliseconds.toDouble(),
      onChanged: (double? newValue) {
        if (newValue == null) {
          onChanged(null);
        } else {
          final int ms = newValue.round().clamp(0, 9999999);
          onChanged(Duration(milliseconds: ms));
        }
      },
      defaultValueForInput: defaultValueForInput,
      step: step,
    );
  }
}
