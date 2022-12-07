import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timer/app/core/language/language.model.dart';

import 'adapters.dart';

class AppStorage {
  // ignore: unused_field
  Box? _box;

  /// for initialling app local storage
  Future<void> initAppStorage() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ThemeModeAdapter());
    Hive.registerAdapter(LanguageModelAdapter());

    _box = await Hive.openBox('timer');
  }

  final _appTheme = 'theme';
  ThemeMode getAppThemeMode() {
    return _box?.get(_appTheme, defaultValue: ThemeMode.system);
  }

  Future<void> putAppThemeMode(ThemeMode mode) async {
    return _box?.put(_appTheme, mode);
  }

  final _appLanguage = 'language';
  LanguageModel? getAppLanguage() {
    return _box?.get(_appLanguage);
  }

  Future<void> putAppLanguage(LanguageModel lang) async {
    return _box?.put(_appLanguage, lang);
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
