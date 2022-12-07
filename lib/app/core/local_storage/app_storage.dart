import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'adapters.dart';

class AppStorage {
  // ignore: unused_field
  Box? _box;

  /// for initialling app local storage
  Future<void> initAppStorage() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ThemeModeAdapter());

    _box = await Hive.openBox('timer');
  }

  final _appTheme = 'theme';
  ThemeMode getAppThemeMode() {
    return _box?.get(_appTheme, defaultValue: ThemeMode.system);
  }

  Future<void> putAppThemeMode(ThemeMode mode) async {
    return _box?.put(_appTheme, mode);
  }

  /// for clearing all data in box
  Future<void> clearAllData() async {
    await _box?.clear();
  }
}

final appStorageProvider = Provider<AppStorage>(
  (_) {
    throw UnimplementedError();
  },
);
