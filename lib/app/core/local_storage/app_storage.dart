import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timer/app/core/language/language.model.dart';
import 'package:timer/app/features/settings/models/sound_model.dart';
import 'package:timer/app/features/settings/models/vibration_model.dart';

import 'adapters.dart';

class AppStorage {
  // ignore: unused_field
  Box? _box;

  /// for initialling app local storage
  Future<void> initAppStorage() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ThemeModeAdapter());
    Hive.registerAdapter(LanguageModelAdapter());
    Hive.registerAdapter(SoundModelAdapter());
    Hive.registerAdapter(VibrationModelAdapter());

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

  final _alarmSound = 'alarm-sound';
  SoundModel? getAlarmSound() {
    return _box?.get(_alarmSound);
  }

  Future<void> putAlarmSound(SoundModel sound) async {
    return _box?.put(_alarmSound, sound);
  }

  final _detentsSound = 'detents-sound';
  SoundModel? getDetentsSound() {
    return _box?.get(_detentsSound);
  }

  Future<void> putDetentsSound(SoundModel sound) async {
    return _box?.put(_detentsSound, sound);
  }

  final _alarmVibration = 'alarm-vibration';
  VibrationModel? getAlarmVibration() {
    return _box?.get(_alarmVibration);
  }

  Future<void> putAlarmVibration(VibrationModel vibration) async {
    return _box?.put(_alarmVibration, vibration);
  }

  final _vibrationEnabled = 'vibration-enabled';
  bool getVibrationEnabled() {
    /// Vibrations are disabled by default
    return _box?.get(_vibrationEnabled, defaultValue: false);
  }

  Future<void> resetVibrationsSettings() async {
    final keys = <String>[_alarmVibration, _vibrationEnabled];
    return _box?.deleteAll(keys);
  }

  Future<void> putVibrationEnabled(bool isEnabled) async {
    return _box?.put(_vibrationEnabled, isEnabled);
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
