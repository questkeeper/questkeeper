// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'spaces_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Spaces _$SpacesFromJson(Map<String, dynamic> json) {
  return _Spaces.fromJson(json);
}

/// @nodoc
mixin _$Spaces {
  int? get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;

  /// Serializes this Spaces to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Spaces
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpacesCopyWith<Spaces> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpacesCopyWith<$Res> {
  factory $SpacesCopyWith(Spaces value, $Res Function(Spaces) then) =
      _$SpacesCopyWithImpl<$Res, Spaces>;
  @useResult
  $Res call({int? id, String title, DateTime? updatedAt, String? color});
}

/// @nodoc
class _$SpacesCopyWithImpl<$Res, $Val extends Spaces>
    implements $SpacesCopyWith<$Res> {
  _$SpacesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Spaces
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = null,
    Object? updatedAt = freezed,
    Object? color = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpacesImplCopyWith<$Res> implements $SpacesCopyWith<$Res> {
  factory _$$SpacesImplCopyWith(
          _$SpacesImpl value, $Res Function(_$SpacesImpl) then) =
      __$$SpacesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? id, String title, DateTime? updatedAt, String? color});
}

/// @nodoc
class __$$SpacesImplCopyWithImpl<$Res>
    extends _$SpacesCopyWithImpl<$Res, _$SpacesImpl>
    implements _$$SpacesImplCopyWith<$Res> {
  __$$SpacesImplCopyWithImpl(
      _$SpacesImpl _value, $Res Function(_$SpacesImpl) _then)
      : super(_value, _then);

  /// Create a copy of Spaces
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = null,
    Object? updatedAt = freezed,
    Object? color = freezed,
  }) {
    return _then(_$SpacesImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpacesImpl implements _Spaces {
  const _$SpacesImpl(
      {this.id, required this.title, this.updatedAt, this.color});

  factory _$SpacesImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpacesImplFromJson(json);

  @override
  final int? id;
  @override
  final String title;
  @override
  final DateTime? updatedAt;
  @override
  final String? color;

  @override
  String toString() {
    return 'Spaces(id: $id, title: $title, updatedAt: $updatedAt, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpacesImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.color, color) || other.color == color));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, updatedAt, color);

  /// Create a copy of Spaces
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpacesImplCopyWith<_$SpacesImpl> get copyWith =>
      __$$SpacesImplCopyWithImpl<_$SpacesImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpacesImplToJson(
      this,
    );
  }
}

abstract class _Spaces implements Spaces {
  const factory _Spaces(
      {final int? id,
      required final String title,
      final DateTime? updatedAt,
      final String? color}) = _$SpacesImpl;

  factory _Spaces.fromJson(Map<String, dynamic> json) = _$SpacesImpl.fromJson;

  @override
  int? get id;
  @override
  String get title;
  @override
  DateTime? get updatedAt;
  @override
  String? get color;

  /// Create a copy of Spaces
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpacesImplCopyWith<_$SpacesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
