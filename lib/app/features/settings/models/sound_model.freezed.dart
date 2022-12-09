// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sound_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SoundModel _$SoundModelFromJson(Map<String, dynamic> json) {
  return _SoundModel.fromJson(json);
}

/// @nodoc
mixin _$SoundModel {
  String get name => throw _privateConstructorUsedError;
  String get path => throw _privateConstructorUsedError;
  dynamic get isAsset => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SoundModelCopyWith<SoundModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SoundModelCopyWith<$Res> {
  factory $SoundModelCopyWith(
          SoundModel value, $Res Function(SoundModel) then) =
      _$SoundModelCopyWithImpl<$Res, SoundModel>;
  @useResult
  $Res call({String name, String path, dynamic isAsset});
}

/// @nodoc
class _$SoundModelCopyWithImpl<$Res, $Val extends SoundModel>
    implements $SoundModelCopyWith<$Res> {
  _$SoundModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? path = null,
    Object? isAsset = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      isAsset: freezed == isAsset
          ? _value.isAsset
          : isAsset // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SoundModelCopyWith<$Res>
    implements $SoundModelCopyWith<$Res> {
  factory _$$_SoundModelCopyWith(
          _$_SoundModel value, $Res Function(_$_SoundModel) then) =
      __$$_SoundModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String path, dynamic isAsset});
}

/// @nodoc
class __$$_SoundModelCopyWithImpl<$Res>
    extends _$SoundModelCopyWithImpl<$Res, _$_SoundModel>
    implements _$$_SoundModelCopyWith<$Res> {
  __$$_SoundModelCopyWithImpl(
      _$_SoundModel _value, $Res Function(_$_SoundModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? path = null,
    Object? isAsset = freezed,
  }) {
    return _then(_$_SoundModel(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      isAsset: freezed == isAsset ? _value.isAsset! : isAsset,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_SoundModel extends _SoundModel {
  const _$_SoundModel(
      {required this.name, required this.path, this.isAsset = true})
      : super._();

  factory _$_SoundModel.fromJson(Map<String, dynamic> json) =>
      _$$_SoundModelFromJson(json);

  @override
  final String name;
  @override
  final String path;
  @override
  @JsonKey()
  final dynamic isAsset;

  @override
  String toString() {
    return 'SoundModel(name: $name, path: $path, isAsset: $isAsset)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SoundModel &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.path, path) || other.path == path) &&
            const DeepCollectionEquality().equals(other.isAsset, isAsset));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, path, const DeepCollectionEquality().hash(isAsset));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SoundModelCopyWith<_$_SoundModel> get copyWith =>
      __$$_SoundModelCopyWithImpl<_$_SoundModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SoundModelToJson(
      this,
    );
  }
}

abstract class _SoundModel extends SoundModel {
  const factory _SoundModel(
      {required final String name,
      required final String path,
      final dynamic isAsset}) = _$_SoundModel;
  const _SoundModel._() : super._();

  factory _SoundModel.fromJson(Map<String, dynamic> json) =
      _$_SoundModel.fromJson;

  @override
  String get name;
  @override
  String get path;
  @override
  dynamic get isAsset;
  @override
  @JsonKey(ignore: true)
  _$$_SoundModelCopyWith<_$_SoundModel> get copyWith =>
      throw _privateConstructorUsedError;
}
