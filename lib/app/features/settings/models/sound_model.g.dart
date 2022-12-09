// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sound_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_SoundModel _$$_SoundModelFromJson(Map<String, dynamic> json) =>
    _$_SoundModel(
      name: json['name'] as String,
      path: json['path'] as String,
      isAsset: json['isAsset'] ?? true,
    );

Map<String, dynamic> _$$_SoundModelToJson(_$_SoundModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'path': instance.path,
      'isAsset': instance.isAsset,
    };
