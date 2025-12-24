// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'return_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReturnModel {
  String get message;
  bool get success;
  dynamic get data;
  String? get error;

  /// Create a copy of ReturnModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReturnModelCopyWith<ReturnModel> get copyWith =>
      _$ReturnModelCopyWithImpl<ReturnModel>(this as ReturnModel, _$identity);

  /// Serializes this ReturnModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReturnModel &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.success, success) || other.success == success) &&
            const DeepCollectionEquality().equals(other.data, data) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message, success,
      const DeepCollectionEquality().hash(data), error);

  @override
  String toString() {
    return 'ReturnModel(message: $message, success: $success, data: $data, error: $error)';
  }
}

/// @nodoc
abstract mixin class $ReturnModelCopyWith<$Res> {
  factory $ReturnModelCopyWith(
          ReturnModel value, $Res Function(ReturnModel) _then) =
      _$ReturnModelCopyWithImpl;
  @useResult
  $Res call({String message, bool success, dynamic data, String? error});
}

/// @nodoc
class _$ReturnModelCopyWithImpl<$Res> implements $ReturnModelCopyWith<$Res> {
  _$ReturnModelCopyWithImpl(this._self, this._then);

  final ReturnModel _self;
  final $Res Function(ReturnModel) _then;

  /// Create a copy of ReturnModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? success = null,
    Object? data = freezed,
    Object? error = freezed,
  }) {
    return _then(_self.copyWith(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      success: null == success
          ? _self.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: freezed == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as dynamic,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ReturnModel].
extension ReturnModelPatterns on ReturnModel {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ReturnModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReturnModel() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ReturnModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReturnModel():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ReturnModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReturnModel() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String message, bool success, dynamic data, String? error)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReturnModel() when $default != null:
        return $default(_that.message, _that.success, _that.data, _that.error);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String message, bool success, dynamic data, String? error)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReturnModel():
        return $default(_that.message, _that.success, _that.data, _that.error);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String message, bool success, dynamic data, String? error)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReturnModel() when $default != null:
        return $default(_that.message, _that.success, _that.data, _that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ReturnModel implements ReturnModel {
  const _ReturnModel(
      {required this.message, required this.success, this.data, this.error});
  factory _ReturnModel.fromJson(Map<String, dynamic> json) =>
      _$ReturnModelFromJson(json);

  @override
  final String message;
  @override
  final bool success;
  @override
  final dynamic data;
  @override
  final String? error;

  /// Create a copy of ReturnModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ReturnModelCopyWith<_ReturnModel> get copyWith =>
      __$ReturnModelCopyWithImpl<_ReturnModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ReturnModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ReturnModel &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.success, success) || other.success == success) &&
            const DeepCollectionEquality().equals(other.data, data) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message, success,
      const DeepCollectionEquality().hash(data), error);

  @override
  String toString() {
    return 'ReturnModel(message: $message, success: $success, data: $data, error: $error)';
  }
}

/// @nodoc
abstract mixin class _$ReturnModelCopyWith<$Res>
    implements $ReturnModelCopyWith<$Res> {
  factory _$ReturnModelCopyWith(
          _ReturnModel value, $Res Function(_ReturnModel) _then) =
      __$ReturnModelCopyWithImpl;
  @override
  @useResult
  $Res call({String message, bool success, dynamic data, String? error});
}

/// @nodoc
class __$ReturnModelCopyWithImpl<$Res> implements _$ReturnModelCopyWith<$Res> {
  __$ReturnModelCopyWithImpl(this._self, this._then);

  final _ReturnModel _self;
  final $Res Function(_ReturnModel) _then;

  /// Create a copy of ReturnModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
    Object? success = null,
    Object? data = freezed,
    Object? error = freezed,
  }) {
    return _then(_ReturnModel(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      success: null == success
          ? _self.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: freezed == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as dynamic,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
