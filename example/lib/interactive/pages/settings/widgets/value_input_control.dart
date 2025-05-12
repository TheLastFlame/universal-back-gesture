import 'package:flutter/material.dart';
import 'package:universal_back_gesture_example/interactive/pages/settings/widgets/pixel_value_selector.dart';

class ValueInputControl extends StatelessWidget {
  const ValueInputControl({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.defaultValueForInput = 0.0,
    this.clearButtonTooltip = 'Use default',
    this.step = 1.0,
  });

  final String label;
  final double? value;
  final ValueChanged<double?> onChanged;
  final double defaultValueForInput;
  final String clearButtonTooltip;
  final double step;

  @override
  Widget build(BuildContext context) {
    final double displayValue = value ?? defaultValueForInput;

    return SizedBox(
      height: 56,
      child: Row(
        children: [
          Expanded(child: Text(label)),
          PixelValueSelector(
            value: displayValue,
            onChanged: onChanged,
            step: step,
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.clear),
            tooltip: clearButtonTooltip,
            onPressed: () {
              onChanged(defaultValueForInput);
            },
          ),
        ],
      ),
    );
  }
}
