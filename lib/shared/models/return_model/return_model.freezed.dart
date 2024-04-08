// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'return_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ReturnModel {
  String get message => throw _privateConstructorUsedError;
  bool get success => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ReturnModelCopyWith<ReturnModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReturnModelCopyWith<$Res> {
  factory $ReturnModelCopyWith(
          ReturnModel value, $Res Function(ReturnModel) then) =
      _$ReturnModelCopyWithImpl<$Res, ReturnModel>;
  @useResult
  $Res call({String message, bool success, String? error});
}

/// @nodoc
class _$ReturnModelCopyWithImpl<$Res, $Val extends ReturnModel>
    implements $ReturnModelCopyWith<$Res> {
  _$ReturnModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? success = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReturnModelImplCopyWith<$Res>
    implements $ReturnModelCopyWith<$Res> {
  factory _$$ReturnModelImplCopyWith(
          _$ReturnModelImpl value, $Res Function(_$ReturnModelImpl) then) =
      __$$ReturnModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, bool success, String? error});
}

/// @nodoc
class __$$ReturnModelImplCopyWithImpl<$Res>
    extends _$ReturnModelCopyWithImpl<$Res, _$ReturnModelImpl>
    implements _$$ReturnModelImplCopyWith<$Res> {
  __$$ReturnModelImplCopyWithImpl(
      _$ReturnModelImpl _value, $Res Function(_$ReturnModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? success = null,
    Object? error = freezed,
  }) {
    return _then(_$ReturnModelImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ReturnModelImpl implements _ReturnModel {
  const _$ReturnModelImpl(
      {required this.message, required this.success, this.error});

  @override
  final String message;
  @override
  final bool success;
  @override
  final String? error;

  @override
  String toString() {
    return 'ReturnModel(message: $message, success: $success, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReturnModelImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, success, error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReturnModelImplCopyWith<_$ReturnModelImpl> get copyWith =>
      __$$ReturnModelImplCopyWithImpl<_$ReturnModelImpl>(this, _$identity);
}

abstract class _ReturnModel implements ReturnModel {
  const factory _ReturnModel(
      {required final String message,
      required final bool success,
      final String? error}) = _$ReturnModelImpl;

  @override
  String get message;
  @override
  bool get success;
  @override
  String? get error;
  @override
  @JsonKey(ignore: true)
  _$$ReturnModelImplCopyWith<_$ReturnModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
