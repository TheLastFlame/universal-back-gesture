import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData().withUpdatedSliders;
final ThemeData darkTheme = ThemeData.dark().withUpdatedSliders;

extension UpdatedThemeData on ThemeData {
  ThemeData get withUpdatedSliders => copyWith(
    //ignore: deprecated_member_use
    sliderTheme: SliderThemeData(year2023: false, padding: EdgeInsets.zero),
  );
}
