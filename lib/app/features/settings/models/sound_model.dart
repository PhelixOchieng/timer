import 'package:freezed_annotation/freezed_annotation.dart';

part 'sound_model.freezed.dart';
part 'sound_model.g.dart';

@freezed
class SoundModel with _$SoundModel {
  const factory SoundModel({
    required String name,
    required String path,
    @Default(true) isAsset,
  }) = _SoundModel;

  const SoundModel._();

  factory SoundModel.fromJson(Map<String, dynamic> json) =>
      _$SoundModelFromJson(json);
}
