import 'package:freezed_annotation/freezed_annotation.dart';

part 'sounds_model.freezed.dart';

@freezed
class SoundModel with _$SoundModel {
  const factory SoundModel({
    required String name,
    required String path,
    @Default(true) isAsset,
  }) = _SoundModel;

  const SoundModel._();

  factory SoundModel.fromJson(Map<String, dynamic> json) {
    return SoundModel(
        name: json['name'],
        path: json['path'],
        isAsset: json['isAsset'] ?? true);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
      'isAsset': isAsset,
    };
  }
}


// class SoundModel {
//   const SoundModel({
//     required this.name,
//     required this.path,
//     this.isAsset = true,
//   });

//   final String name;
//   final String path;
//   final bool isAsset;

//   factory SoundModel.fromJson(Map<String, dynamic> json) {
//     return SoundModel(
//         name: json['name'],
//         path: json['path'],
//         isAsset: json['isAsset'] ?? true);
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'path': path,
//       'isAsset': isAsset,
//     };
//   }

//   @override
//   String toString() {
//     return 'SoundModel(name: $name, path: $path, isAsset: $isAsset)';
//   }
// }
