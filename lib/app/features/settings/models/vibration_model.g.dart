// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vibration_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_VibrationModel _$$_VibrationModelFromJson(Map<String, dynamic> json) =>
    _$_VibrationModel(
      name: json['name'] as String,
      pattern: (json['pattern'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$$_VibrationModelToJson(_$_VibrationModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'pattern': instance.pattern,
    };
