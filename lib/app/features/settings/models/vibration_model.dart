import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vibration/vibration.dart';

part 'vibration_model.freezed.dart';
part 'vibration_model.g.dart';

@freezed
class VibrationModel with _$VibrationModel {
  const factory VibrationModel({
    required String name,
    required List<int> pattern,
  }) = _VibrationModel;

  const VibrationModel._();

  factory VibrationModel.fromJson(Map<String, dynamic> json) =>
      _$VibrationModelFromJson(json);

  Future<void> vibrate() async {
    await stop();
    await Vibration.vibrate(pattern: pattern);
  }

  Future<void> stop() async {
    await Vibration.cancel();
  }
}
