import 'package:color_fns/color_fns.dart';
import 'package:flutter/material.dart';

extension ThemeX on ThemeData {
  bool get isLightMode => brightness == Brightness.light;

  Color get surfaceColor =>
      isLightMode ? Colors.white : scaffoldBackgroundColor.lighten(0.05);
}

extension NavigationX on BuildContext {
  void swipeTo(Widget target) {
    Navigator.of(this).push(MaterialPageRoute(builder: (_) => target));
  }
}
