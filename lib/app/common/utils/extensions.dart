import 'package:color_fns/color_fns.dart';
import 'package:flutter/material.dart';

extension ThemeX on ThemeData {
  bool get isLightMode => brightness == Brightness.light;

  Color get surfaceColor =>
      isLightMode ? Colors.white : scaffoldBackgroundColor.lighten(0.05);
}
