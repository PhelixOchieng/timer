import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timer/app/core/local_storage/app_storage.dart';
import 'package:vibration/vibration.dart';

import '../models/vibration_model.dart';

class VibrationRepository extends ChangeNotifier {
  final Ref _ref;
  final AppStorage _storage;

  late VibrationModel _selectedAlarmVibration;
  VibrationRepository(this._ref) : _storage = _ref.read(appStorageProvider) {
    _initVibrationsSettings();
  }

  bool _areVibrationsEnabled = false;
  Future<void> _initVibrationsSettings([bool notify = true]) async {
    _selectedAlarmVibration = vibrations[0];

    final alarmVibration = _storage.getAlarmVibration();
    if (alarmVibration != null) _selectedAlarmVibration = alarmVibration;

    final value = await Vibration.hasVibrator();

    if (value == true) {
      _areVibrationsEnabled = _storage.getVibrationEnabled();
      debugPrint('P: $_areVibrationsEnabled');
    } else {
      _areVibrationsEnabled = false;
    }

    if (notify) notifyListeners();
  }

  void disableVibrations() async {
    _areVibrationsEnabled = false;
    await _storage.putVibrationEnabled(false);
    notifyListeners();
  }

  void enableVibrations() async {
    final hasVibrator = await Vibration.hasVibrator();

    if (hasVibrator == true) {
      _areVibrationsEnabled = true;
      await _storage.putVibrationEnabled(true);
      notifyListeners();
    }
  }

  Future<void> saveAlarmVibration(VibrationModel vibration) async {
    _selectedAlarmVibration = vibration;
    await _storage.putAlarmVibration(vibration);
    notifyListeners();
  }

  Future<bool> canEnableVibrations() async {
    final enable = await Vibration.hasVibrator();
    if (enable == true) return true;
    return false;
  }

  bool _isResetting = false;
  Future<void> reset() async {
    _isResetting = true;
    try {
      await _storage.resetVibrationsSettings();
      await _initVibrationsSettings(false);
    } finally {
      _isResetting = false;
      notifyListeners();
    }
  }

  VibrationModel get alarmVibration => _selectedAlarmVibration;
  bool get areVibrationsEnabled => _areVibrationsEnabled;
  bool get isResetting => _isResetting;

  final List<VibrationModel> vibrations = const [
    VibrationModel(name: 'Flat', pattern: [500, 1000]),
    VibrationModel(name: 'Trail', pattern: [0, 100, 200, 700]),
    VibrationModel(
      name: 'Fast',
      pattern: [0, 200, 100, 200, 100, 200, 100, 200],
    ),
    VibrationModel(name: 'Bounce', pattern: [0, 100, 150, 100, 75, 100, 470]),
  ];
}

final vibrationsProvider = ChangeNotifierProvider<VibrationRepository>((ref) {
  return VibrationRepository(ref);
});
