import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timer/app/core/local_storage/app_storage.dart';

import '../models/sounds_model.dart';

class SoundsRepository extends ChangeNotifier {
  final Ref _ref;
  final AppStorage _storage;

  late SoundModel _selectedAlarmSound;
  late SoundModel _selectedDetentsSound;
  SoundsRepository(this._ref) : _storage = _ref.read(appStorageProvider) {
    _selectedAlarmSound = sounds[0];
    _selectedDetentsSound = sounds[1];

    final alarmSound = _storage.getAlarmSound();
    if (alarmSound != null) _selectedAlarmSound = alarmSound;

    final detentsSound = _storage.getDetentsSound();
    if (detentsSound != null) _selectedDetentsSound = detentsSound;
  }

  Future<void> saveAlarmSound(SoundModel sound) async {
    _selectedAlarmSound = sound;
    await _storage.putAlarmSound(sound);
    notifyListeners();
  }

  Future<void> saveDetentsSound(SoundModel sound) async {
    _selectedDetentsSound = sound;
    await _storage.putDetentsSound(sound);
    notifyListeners();
  }

  SoundModel get alarmSound => _selectedAlarmSound;
  SoundModel get detentsSound => _selectedDetentsSound;

  // Do not change the order of the first two sounds 🙂
  final List<SoundModel> sounds = const [
    SoundModel(name: 'Bell 1', path: 'bell_1.mp3', isAsset: true),
    SoundModel(name: 'Click', path: 'click_1.mp3', isAsset: true),
    SoundModel(name: 'Bell 2', path: 'bell_2.mp3', isAsset: true),
    SoundModel(name: 'Bell 3', path: 'bell_3.mp3', isAsset: true),
    SoundModel(name: 'Beep 2', path: 'beep_1.mp3', isAsset: true),
  ];
}

final soundsProvider = ChangeNotifierProvider<SoundsRepository>((ref) {
  return SoundsRepository(ref);
});
