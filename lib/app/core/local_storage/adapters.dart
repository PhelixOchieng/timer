import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

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
