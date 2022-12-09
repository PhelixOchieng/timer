// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vibration_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

VibrationModel _$VibrationModelFromJson(Map<String, dynamic> json) {
  return _VibrationModel.fromJson(json);
}

/// @nodoc
mixin _$VibrationModel {
  String get name => throw _privateConstructorUsedError;
  List<int> get pattern => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VibrationModelCopyWith<VibrationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VibrationModelCopyWith<$Res> {
  factory $VibrationModelCopyWith(
          VibrationModel value, $Res Function(VibrationModel) then) =
      _$VibrationModelCopyWithImpl<$Res, VibrationModel>;
  @useResult
  $Res call({String name, List<int> pattern});
}

/// @nodoc
class _$VibrationModelCopyWithImpl<$Res, $Val extends VibrationModel>
    implements $VibrationModelCopyWith<$Res> {
  _$VibrationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? pattern = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      pattern: null == pattern
          ? _value.pattern
          : pattern // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_VibrationModelCopyWith<$Res>
    implements $VibrationModelCopyWith<$Res> {
  factory _$$_VibrationModelCopyWith(
          _$_VibrationModel value, $Res Function(_$_VibrationModel) then) =
      __$$_VibrationModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, List<int> pattern});
}

/// @nodoc
class __$$_VibrationModelCopyWithImpl<$Res>
    extends _$VibrationModelCopyWithImpl<$Res, _$_VibrationModel>
    implements _$$_VibrationModelCopyWith<$Res> {
  __$$_VibrationModelCopyWithImpl(
      _$_VibrationModel _value, $Res Function(_$_VibrationModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? pattern = null,
  }) {
    return _then(_$_VibrationModel(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      pattern: null == pattern
          ? _value._pattern
          : pattern // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_VibrationModel extends _VibrationModel {
  const _$_VibrationModel(
      {required this.name, required final List<int> pattern})
      : _pattern = pattern,
        super._();

  factory _$_VibrationModel.fromJson(Map<String, dynamic> json) =>
      _$$_VibrationModelFromJson(json);

  @override
  final String name;
  final List<int> _pattern;
  @override
  List<int> get pattern {
    if (_pattern is EqualUnmodifiableListView) return _pattern;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pattern);
  }

  @override
  String toString() {
    return 'VibrationModel(name: $name, pattern: $pattern)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_VibrationModel &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._pattern, _pattern));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, const DeepCollectionEquality().hash(_pattern));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_VibrationModelCopyWith<_$_VibrationModel> get copyWith =>
      __$$_VibrationModelCopyWithImpl<_$_VibrationModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_VibrationModelToJson(
      this,
    );
  }
}

abstract class _VibrationModel extends VibrationModel {
  const factory _VibrationModel(
      {required final String name,
      required final List<int> pattern}) = _$_VibrationModel;
  const _VibrationModel._() : super._();

  factory _VibrationModel.fromJson(Map<String, dynamic> json) =
      _$_VibrationModel.fromJson;

  @override
  String get name;
  @override
  List<int> get pattern;
  @override
  @JsonKey(ignore: true)
  _$$_VibrationModelCopyWith<_$_VibrationModel> get copyWith =>
      throw _privateConstructorUsedError;
}
