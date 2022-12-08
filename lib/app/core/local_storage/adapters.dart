import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:timer/app/core/language/language.model.dart';
import 'package:timer/app/features/settings/models/sounds_model.dart';

class ThemeModeAdapter extends TypeAdapter<ThemeMode> {
  @override
  final typeId = 0;

  @override
  ThemeMode read(BinaryReader reader) {
    final readValue = reader.read() as String;
    return ThemeMode.values.firstWhere((mode) => mode.name == readValue);
  }

  @override
  void write(BinaryWriter writer, ThemeMode obj) {
    writer.write(obj.name);
  }
}

class LanguageModelAdapter extends TypeAdapter<LanguageModel> {
  @override
  final typeId = 1;

  @override
  LanguageModel read(BinaryReader reader) {
    final readValue = Map<String, dynamic>.from(reader.read());
    return LanguageModel.fromJson(readValue);
  }

  @override
  void write(BinaryWriter writer, LanguageModel obj) {
    writer.write(obj.toJson());
  }
}

class SoundModelAdapter extends TypeAdapter<SoundModel> {
  @override
  final typeId = 2;

  @override
  SoundModel read(BinaryReader reader) {
    final readValue = Map<String, dynamic>.from(reader.read());
    return SoundModel.fromJson(readValue);
  }

  @override
  void write(BinaryWriter writer, SoundModel obj) {
    writer.write(obj.toJson());
  }
}
