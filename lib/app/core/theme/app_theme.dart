import 'package:color_fns/color_fns.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:timer/app/common/constants/constants.dart';
import 'package:timer/app/common/utils/extensions.dart';
import 'package:timer/app/core/local_storage/app_storage.dart';

class AppTheme extends ChangeNotifier {
  final Ref _ref;
  final AppStorage _storage;

  ThemeMode _themeMode = ThemeMode.system;
  AppTheme(this._ref) : _storage = _ref.read(appStorageProvider) {
    _themeMode = _storage.getAppThemeMode();
  }

  /// Used to preview how the app would look without commiting to the theme
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  /// Actually writes the given theme to disk
  Future<void> saveThemeMode([ThemeMode? mode]) async {
    _themeMode = mode ?? _themeMode;
    await _storage.putAppThemeMode(_themeMode);
    notifyListeners();
  }

  final colorScheme = ColorScheme.fromSeed(
    seedColor: kPrimaryColor,
    primary: kPrimaryColor,
    onPrimary: Colors.white,
    secondary: kSecondaryColor,
  );
  Color _getStateColor({
    required Set<MaterialState> states,
    required Color inactiveColor,
    required Color disabledColor,
    Color? activeColor,
  }) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
      MaterialState.selected,
    };

    if (states.isEmpty) return inactiveColor;
    if (states.contains(MaterialState.disabled)) {
      return disabledColor;
    }

    return activeColor ?? colorScheme.primary;
  }

  ThemeData _commonTheme(ThemeData base) {
    final theme = base.copyWith(
      useMaterial3: true,
      primaryColor: kPrimaryColor,
      brightness: base.brightness,
      colorScheme: colorScheme,
      textTheme: base.textTheme.copyWith(
        bodyMedium: base.textTheme.bodyMedium?.copyWith(
          fontSize: 16,
        ),
      ),
      appBarTheme: base.appBarTheme.copyWith(
        centerTitle: true,
        elevation: 3,
        titleSpacing: 0,
      ),
      tabBarTheme: base.tabBarTheme.copyWith(
        labelColor: kPrimaryColor,
        indicatorSize: TabBarIndicatorSize.label,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(
            width: 3,
            color: kPrimaryColor,
          ),
          insets: EdgeInsets.symmetric(vertical: 8),
        ),
      ),
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
        ),
      ),
      listTileTheme: base.listTileTheme.copyWith(
        contentPadding: EdgeInsets.symmetric(
            vertical: 0, horizontal: kAppPadding.horizontal / 2),
      ),
    );

    return theme;
  }

  /// for getting light theme
  ThemeData get lightTheme {
    final base = _commonTheme(ThemeData.light());
    final scaffoldBackgroundColor = base.colorScheme.primary.lighten(0.47);
    return base.copyWith(
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      appBarTheme: base.appBarTheme.copyWith(
        color: scaffoldBackgroundColor,
        elevation: 0,
      ),
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        border: base.inputDecorationTheme.border?.copyWith(
          borderSide: const BorderSide(color: Colors.black12),
        ),
      ),
      switchTheme: base.switchTheme.copyWith(
        thumbColor: MaterialStateProperty.resolveWith((states) =>
            _getStateColor(
                states: states,
                inactiveColor: Colors.white,
                disabledColor: Colors.black26)),
        trackColor: MaterialStateProperty.resolveWith((states) =>
            _getStateColor(
                states: states,
                activeColor: colorScheme.primaryContainer,
                inactiveColor: colorScheme.primaryContainer,
                disabledColor: Colors.black12)),
      ),
      radioTheme: base.radioTheme.copyWith(
        fillColor: MaterialStateColor.resolveWith((states) => _getStateColor(
            states: states,
            inactiveColor: Colors.black38,
            disabledColor: Colors.black12)),
      ),
    );
  }

  /// for getting dark theme
  ThemeData get darkTheme {
    final base = _commonTheme(ThemeData.dark());

    final colorScheme = base.colorScheme;
    return base.copyWith(
      scaffoldBackgroundColor: colorScheme.primary.darken(0.45),
      appBarTheme: base.appBarTheme.copyWith(
        color: colorScheme.primary.darken(0.43),
        foregroundColor: kTextColorDark,
      ),
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        border: base.inputDecorationTheme.border?.copyWith(
          borderSide: const BorderSide(color: Colors.white38),
        ),
      ),
    );
  }

  ThemeMode get themeMode => _themeMode;
}

/// for providing app theme [AppTheme]
final appThemeProvider =
    ChangeNotifierProvider<AppTheme>((ref) => AppTheme(ref));
