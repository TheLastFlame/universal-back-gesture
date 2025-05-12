import 'package:flutter/material.dart';
import 'package:universal_back_gesture/back_gesture_config.dart';
import 'package:universal_back_gesture_example/interactive/pages/settings/widgets/pixel_value_selector.dart';

class GestureMeasurementControl extends StatelessWidget {
  const GestureMeasurementControl({
    super.key,
    required this.label,
    required this.measurement,
    required this.onMeasurementChanged,
    required this.defaultPercentage,
    required this.defaultPixels,
    required this.pixelInputLabel,
    this.pixelStep,
  });

  final String label;
  final GestureMeasurement measurement;
  final Function(GestureMeasurement) onMeasurementChanged;
  final double defaultPercentage;
  final double defaultPixels;
  final String pixelInputLabel;
  final double? pixelStep;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleSmall),
        SizedBox(
          height: 56,
          child: Row(
            children: [
              Expanded(
                child: AnimatedSwitcher(
                  duration: Durations.medium2,
                  child: switch (measurement.type) {
                    GestureMeasurementType.percentage => Slider(
                      value: measurement.value,
                      divisions: 20,
                      label: (measurement.value * 100).floor().toString(),
                      onChanged: (value) {
                        onMeasurementChanged(
                          GestureMeasurement.percentage(value),
                        );
                      },
                    ),
                    GestureMeasurementType.pixels => PixelValueSelector(
                      label: pixelInputLabel,
                      value: measurement.value,
                      onChanged: (value) {
                        onMeasurementChanged(GestureMeasurement.pixels(value));
                      },
                      step: pixelStep ?? 1.0,
                    ),
                  },
                ),
              ),
              SizedBox(width: 16),
              SegmentedButton<GestureMeasurementType>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment<GestureMeasurementType>(
                    value: GestureMeasurementType.percentage,
                    label: Text('%'),
                  ),
                  ButtonSegment<GestureMeasurementType>(
                    value: GestureMeasurementType.pixels,
                    label: Text('dp'),
                  ),
                ],
                selected: {measurement.type},
                onSelectionChanged: (Set<GestureMeasurementType> newSelection) {
                  onMeasurementChanged(switch (newSelection.first) {
                    GestureMeasurementType.percentage =>
                      GestureMeasurement.percentage(defaultPercentage),
                    GestureMeasurementType.pixels => GestureMeasurement.pixels(
                      defaultPixels,
                    ),
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
