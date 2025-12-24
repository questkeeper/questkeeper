// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'spaces_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Spaces {
  int? get id;
  String get title;
  DateTime? get updatedAt;
  String get spaceType;
  Map<String, List<int>> get notificationTimes;

  /// Create a copy of Spaces
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SpacesCopyWith<Spaces> get copyWith =>
      _$SpacesCopyWithImpl<Spaces>(this as Spaces, _$identity);

  /// Serializes this Spaces to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Spaces &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.spaceType, spaceType) ||
                other.spaceType == spaceType) &&
            const DeepCollectionEquality()
                .equals(other.notificationTimes, notificationTimes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, updatedAt, spaceType,
      const DeepCollectionEquality().hash(notificationTimes));

  @override
  String toString() {
    return 'Spaces(id: $id, title: $title, updatedAt: $updatedAt, spaceType: $spaceType, notificationTimes: $notificationTimes)';
  }
}

/// @nodoc
abstract mixin class $SpacesCopyWith<$Res> {
  factory $SpacesCopyWith(Spaces value, $Res Function(Spaces) _then) =
      _$SpacesCopyWithImpl;
  @useResult
  $Res call(
      {int? id,
      String title,
      DateTime? updatedAt,
      String spaceType,
      Map<String, List<int>> notificationTimes});
}

/// @nodoc
class _$SpacesCopyWithImpl<$Res> implements $SpacesCopyWith<$Res> {
  _$SpacesCopyWithImpl(this._self, this._then);

  final Spaces _self;
  final $Res Function(Spaces) _then;

  /// Create a copy of Spaces
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = null,
    Object? updatedAt = freezed,
    Object? spaceType = null,
    Object? notificationTimes = null,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      spaceType: null == spaceType
          ? _self.spaceType
          : spaceType // ignore: cast_nullable_to_non_nullable
              as String,
      notificationTimes: null == notificationTimes
          ? _self.notificationTimes
          : notificationTimes // ignore: cast_nullable_to_non_nullable
              as Map<String, List<int>>,
    ));
  }
}

/// Adds pattern-matching-related methods to [Spaces].
extension SpacesPatterns on Spaces {
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
    TResult Function(_Spaces value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Spaces() when $default != null:
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
    TResult Function(_Spaces value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Spaces():
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
    TResult? Function(_Spaces value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Spaces() when $default != null:
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
    TResult Function(int? id, String title, DateTime? updatedAt,
            String spaceType, Map<String, List<int>> notificationTimes)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Spaces() when $default != null:
        return $default(_that.id, _that.title, _that.updatedAt, _that.spaceType,
            _that.notificationTimes);
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
    TResult Function(int? id, String title, DateTime? updatedAt,
            String spaceType, Map<String, List<int>> notificationTimes)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Spaces():
        return $default(_that.id, _that.title, _that.updatedAt, _that.spaceType,
            _that.notificationTimes);
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
    TResult? Function(int? id, String title, DateTime? updatedAt,
            String spaceType, Map<String, List<int>> notificationTimes)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Spaces() when $default != null:
        return $default(_that.id, _that.title, _that.updatedAt, _that.spaceType,
            _that.notificationTimes);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Spaces implements Spaces {
  const _Spaces(
      {this.id,
      required this.title,
      this.updatedAt,
      required this.spaceType,
      required final Map<String, List<int>> notificationTimes})
      : _notificationTimes = notificationTimes;
  factory _Spaces.fromJson(Map<String, dynamic> json) => _$SpacesFromJson(json);

  @override
  final int? id;
  @override
  final String title;
  @override
  final DateTime? updatedAt;
  @override
  final String spaceType;
  final Map<String, List<int>> _notificationTimes;
  @override
  Map<String, List<int>> get notificationTimes {
    if (_notificationTimes is EqualUnmodifiableMapView)
      return _notificationTimes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_notificationTimes);
  }

  /// Create a copy of Spaces
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SpacesCopyWith<_Spaces> get copyWith =>
      __$SpacesCopyWithImpl<_Spaces>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SpacesToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Spaces &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.spaceType, spaceType) ||
                other.spaceType == spaceType) &&
            const DeepCollectionEquality()
                .equals(other._notificationTimes, _notificationTimes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, updatedAt, spaceType,
      const DeepCollectionEquality().hash(_notificationTimes));

  @override
  String toString() {
    return 'Spaces(id: $id, title: $title, updatedAt: $updatedAt, spaceType: $spaceType, notificationTimes: $notificationTimes)';
  }
}

/// @nodoc
abstract mixin class _$SpacesCopyWith<$Res> implements $SpacesCopyWith<$Res> {
  factory _$SpacesCopyWith(_Spaces value, $Res Function(_Spaces) _then) =
      __$SpacesCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? id,
      String title,
      DateTime? updatedAt,
      String spaceType,
      Map<String, List<int>> notificationTimes});
}

/// @nodoc
class __$SpacesCopyWithImpl<$Res> implements _$SpacesCopyWith<$Res> {
  __$SpacesCopyWithImpl(this._self, this._then);

  final _Spaces _self;
  final $Res Function(_Spaces) _then;

  /// Create a copy of Spaces
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? title = null,
    Object? updatedAt = freezed,
    Object? spaceType = null,
    Object? notificationTimes = null,
  }) {
    return _then(_Spaces(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      spaceType: null == spaceType
          ? _self.spaceType
          : spaceType // ignore: cast_nullable_to_non_nullable
              as String,
      notificationTimes: null == notificationTimes
          ? _self._notificationTimes
          : notificationTimes // ignore: cast_nullable_to_non_nullable
              as Map<String, List<int>>,
    ));
  }
}

// dart format on
