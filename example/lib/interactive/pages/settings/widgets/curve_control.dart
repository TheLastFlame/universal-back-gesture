import 'package:flutter/material.dart';
import 'package:universal_back_gesture_example/interactive/pages/settings/settings_page.dart';

class CurveControl extends StatelessWidget {
  const CurveControl({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.curvesMap = const {
      'linear': Curves.linear,
      'decelerate': Curves.decelerate,
      'fastLinearToSlowEaseIn': Curves.fastLinearToSlowEaseIn,
      'ease': Curves.ease,
      'easeIn': Curves.easeIn,
      'easeInToLinear': Curves.easeInToLinear,
      'easeInSine': Curves.easeInSine,
      'easeInQuad': Curves.easeInQuad,
      'easeInCubic': Curves.easeInCubic,
      'easeInQuart': Curves.easeInQuart,
      'easeInQuint': Curves.easeInQuint,
      'easeInExpo': Curves.easeInExpo,
      'easeInCirc': Curves.easeInCirc,
      'easeInBack': Curves.easeInBack,
      'easeOut': Curves.easeOut,
      'linearToEaseOut': Curves.linearToEaseOut,
      'easeOutSine': Curves.easeOutSine,
      'easeOutQuad': Curves.easeOutQuad,
      'easeOutCubic': Curves.easeOutCubic,
      'easeOutQuart': Curves.easeOutQuart,
      'easeOutQuint': Curves.easeOutQuint,
      'easeOutExpo': Curves.easeOutExpo,
      'easeOutCirc': Curves.easeOutCirc,
      'easeOutBack': Curves.easeOutBack,
      'easeInOut': Curves.easeInOut,
      'easeInOutSine': Curves.easeInOutSine,
      'easeInOutQuad': Curves.easeInOutQuad,
      'easeInOutCubic': Curves.easeInOutCubic,
      'easeInOutQuart': Curves.easeInOutQuart,
      'easeInOutQuint': Curves.easeInOutQuint,
      'easeInOutExpo': Curves.easeInOutExpo,
      'easeInOutCirc': Curves.easeInOutCirc,
      'easeInOutBack': Curves.easeInOutBack,
      'fastEaseInToSlowEaseOut': Curves.fastEaseInToSlowEaseOut,
      'fastOutSlowIn': Curves.fastOutSlowIn,
      'slowMiddle': Curves.slowMiddle,
      'bounceIn': Curves.bounceIn,
      'bounceOut': Curves.bounceOut,
      'bounceInOut': Curves.bounceInOut,
      'elasticIn': Curves.elasticIn,
      'elasticOut': Curves.elasticOut,
      'elasticInOut': Curves.elasticInOut,
    },
  });

  final String label;
  final Curve value;
  final ValueChanged<Curve> onChanged;
  final Map<String, Curve> curvesMap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SettingsPage.elementHeight,
      child: Row(
        children: [
          Expanded(child: Text(label)),
          SizedBox(width: 12),
          DropdownMenu<Curve>(
            inputDecorationTheme: InputDecorationTheme(
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            initialSelection: value,
            onSelected: (Curve? newValue) {
              if (newValue != null) {
                onChanged(newValue);
              }
            },
            dropdownMenuEntries: [
              for (final entry in curvesMap.entries)
                DropdownMenuEntry<Curve>(value: entry.value, label: entry.key),
            ],
            width: 220,
          ),
        ],
      ),
    );
  }
}
