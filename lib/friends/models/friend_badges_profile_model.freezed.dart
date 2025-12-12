// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'friend_badges_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FriendBadgesProfileModel {
  List<UserBadge> get badges;
  Map<String, dynamic>? get stats;

  /// Create a copy of FriendBadgesProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FriendBadgesProfileModelCopyWith<FriendBadgesProfileModel> get copyWith =>
      _$FriendBadgesProfileModelCopyWithImpl<FriendBadgesProfileModel>(
          this as FriendBadgesProfileModel, _$identity);

  /// Serializes this FriendBadgesProfileModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FriendBadgesProfileModel &&
            const DeepCollectionEquality().equals(other.badges, badges) &&
            const DeepCollectionEquality().equals(other.stats, stats));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(badges),
      const DeepCollectionEquality().hash(stats));

  @override
  String toString() {
    return 'FriendBadgesProfileModel(badges: $badges, stats: $stats)';
  }
}

/// @nodoc
abstract mixin class $FriendBadgesProfileModelCopyWith<$Res> {
  factory $FriendBadgesProfileModelCopyWith(FriendBadgesProfileModel value,
          $Res Function(FriendBadgesProfileModel) _then) =
      _$FriendBadgesProfileModelCopyWithImpl;
  @useResult
  $Res call({List<UserBadge> badges, Map<String, dynamic>? stats});
}

/// @nodoc
class _$FriendBadgesProfileModelCopyWithImpl<$Res>
    implements $FriendBadgesProfileModelCopyWith<$Res> {
  _$FriendBadgesProfileModelCopyWithImpl(this._self, this._then);

  final FriendBadgesProfileModel _self;
  final $Res Function(FriendBadgesProfileModel) _then;

  /// Create a copy of FriendBadgesProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? badges = null,
    Object? stats = freezed,
  }) {
    return _then(_self.copyWith(
      badges: null == badges
          ? _self.badges
          : badges // ignore: cast_nullable_to_non_nullable
              as List<UserBadge>,
      stats: freezed == stats
          ? _self.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// Adds pattern-matching-related methods to [FriendBadgesProfileModel].
extension FriendBadgesProfileModelPatterns on FriendBadgesProfileModel {
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
    TResult Function(_FriendBadgesProfileModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FriendBadgesProfileModel() when $default != null:
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
    TResult Function(_FriendBadgesProfileModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FriendBadgesProfileModel():
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
    TResult? Function(_FriendBadgesProfileModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FriendBadgesProfileModel() when $default != null:
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
    TResult Function(List<UserBadge> badges, Map<String, dynamic>? stats)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FriendBadgesProfileModel() when $default != null:
        return $default(_that.badges, _that.stats);
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
    TResult Function(List<UserBadge> badges, Map<String, dynamic>? stats)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FriendBadgesProfileModel():
        return $default(_that.badges, _that.stats);
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
    TResult? Function(List<UserBadge> badges, Map<String, dynamic>? stats)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FriendBadgesProfileModel() when $default != null:
        return $default(_that.badges, _that.stats);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _FriendBadgesProfileModel implements FriendBadgesProfileModel {
  const _FriendBadgesProfileModel(
      {required final List<UserBadge> badges,
      final Map<String, dynamic>? stats})
      : _badges = badges,
        _stats = stats;
  factory _FriendBadgesProfileModel.fromJson(Map<String, dynamic> json) =>
      _$FriendBadgesProfileModelFromJson(json);

  final List<UserBadge> _badges;
  @override
  List<UserBadge> get badges {
    if (_badges is EqualUnmodifiableListView) return _badges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_badges);
  }

  final Map<String, dynamic>? _stats;
  @override
  Map<String, dynamic>? get stats {
    final value = _stats;
    if (value == null) return null;
    if (_stats is EqualUnmodifiableMapView) return _stats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Create a copy of FriendBadgesProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FriendBadgesProfileModelCopyWith<_FriendBadgesProfileModel> get copyWith =>
      __$FriendBadgesProfileModelCopyWithImpl<_FriendBadgesProfileModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$FriendBadgesProfileModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FriendBadgesProfileModel &&
            const DeepCollectionEquality().equals(other._badges, _badges) &&
            const DeepCollectionEquality().equals(other._stats, _stats));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_badges),
      const DeepCollectionEquality().hash(_stats));

  @override
  String toString() {
    return 'FriendBadgesProfileModel(badges: $badges, stats: $stats)';
  }
}

/// @nodoc
abstract mixin class _$FriendBadgesProfileModelCopyWith<$Res>
    implements $FriendBadgesProfileModelCopyWith<$Res> {
  factory _$FriendBadgesProfileModelCopyWith(_FriendBadgesProfileModel value,
          $Res Function(_FriendBadgesProfileModel) _then) =
      __$FriendBadgesProfileModelCopyWithImpl;
  @override
  @useResult
  $Res call({List<UserBadge> badges, Map<String, dynamic>? stats});
}

/// @nodoc
class __$FriendBadgesProfileModelCopyWithImpl<$Res>
    implements _$FriendBadgesProfileModelCopyWith<$Res> {
  __$FriendBadgesProfileModelCopyWithImpl(this._self, this._then);

  final _FriendBadgesProfileModel _self;
  final $Res Function(_FriendBadgesProfileModel) _then;

  /// Create a copy of FriendBadgesProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? badges = null,
    Object? stats = freezed,
  }) {
    return _then(_FriendBadgesProfileModel(
      badges: null == badges
          ? _self._badges
          : badges // ignore: cast_nullable_to_non_nullable
              as List<UserBadge>,
      stats: freezed == stats
          ? _self._stats
          : stats // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

// dart format on
