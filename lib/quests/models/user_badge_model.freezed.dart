// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_badge_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserBadge {
  int get id;
  int get progress;
  String get monthYear;
  Badge get badge;
  bool get redeemed;
  String? get earnedAt;
  int get redemptionCount;

  /// Create a copy of UserBadge
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserBadgeCopyWith<UserBadge> get copyWith =>
      _$UserBadgeCopyWithImpl<UserBadge>(this as UserBadge, _$identity);

  /// Serializes this UserBadge to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserBadge &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.monthYear, monthYear) ||
                other.monthYear == monthYear) &&
            (identical(other.badge, badge) || other.badge == badge) &&
            (identical(other.redeemed, redeemed) ||
                other.redeemed == redeemed) &&
            (identical(other.earnedAt, earnedAt) ||
                other.earnedAt == earnedAt) &&
            (identical(other.redemptionCount, redemptionCount) ||
                other.redemptionCount == redemptionCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, progress, monthYear, badge,
      redeemed, earnedAt, redemptionCount);

  @override
  String toString() {
    return 'UserBadge(id: $id, progress: $progress, monthYear: $monthYear, badge: $badge, redeemed: $redeemed, earnedAt: $earnedAt, redemptionCount: $redemptionCount)';
  }
}

/// @nodoc
abstract mixin class $UserBadgeCopyWith<$Res> {
  factory $UserBadgeCopyWith(UserBadge value, $Res Function(UserBadge) _then) =
      _$UserBadgeCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      int progress,
      String monthYear,
      Badge badge,
      bool redeemed,
      String? earnedAt,
      int redemptionCount});

  $BadgeCopyWith<$Res> get badge;
}

/// @nodoc
class _$UserBadgeCopyWithImpl<$Res> implements $UserBadgeCopyWith<$Res> {
  _$UserBadgeCopyWithImpl(this._self, this._then);

  final UserBadge _self;
  final $Res Function(UserBadge) _then;

  /// Create a copy of UserBadge
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? progress = null,
    Object? monthYear = null,
    Object? badge = null,
    Object? redeemed = null,
    Object? earnedAt = freezed,
    Object? redemptionCount = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      progress: null == progress
          ? _self.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as int,
      monthYear: null == monthYear
          ? _self.monthYear
          : monthYear // ignore: cast_nullable_to_non_nullable
              as String,
      badge: null == badge
          ? _self.badge
          : badge // ignore: cast_nullable_to_non_nullable
              as Badge,
      redeemed: null == redeemed
          ? _self.redeemed
          : redeemed // ignore: cast_nullable_to_non_nullable
              as bool,
      earnedAt: freezed == earnedAt
          ? _self.earnedAt
          : earnedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      redemptionCount: null == redemptionCount
          ? _self.redemptionCount
          : redemptionCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }

  /// Create a copy of UserBadge
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BadgeCopyWith<$Res> get badge {
    return $BadgeCopyWith<$Res>(_self.badge, (value) {
      return _then(_self.copyWith(badge: value));
    });
  }
}

/// Adds pattern-matching-related methods to [UserBadge].
extension UserBadgePatterns on UserBadge {
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
    TResult Function(_UserBadge value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserBadge() when $default != null:
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
    TResult Function(_UserBadge value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserBadge():
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
    TResult? Function(_UserBadge value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserBadge() when $default != null:
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
    TResult Function(int id, int progress, String monthYear, Badge badge,
            bool redeemed, String? earnedAt, int redemptionCount)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserBadge() when $default != null:
        return $default(_that.id, _that.progress, _that.monthYear, _that.badge,
            _that.redeemed, _that.earnedAt, _that.redemptionCount);
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
    TResult Function(int id, int progress, String monthYear, Badge badge,
            bool redeemed, String? earnedAt, int redemptionCount)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserBadge():
        return $default(_that.id, _that.progress, _that.monthYear, _that.badge,
            _that.redeemed, _that.earnedAt, _that.redemptionCount);
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
    TResult? Function(int id, int progress, String monthYear, Badge badge,
            bool redeemed, String? earnedAt, int redemptionCount)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserBadge() when $default != null:
        return $default(_that.id, _that.progress, _that.monthYear, _that.badge,
            _that.redeemed, _that.earnedAt, _that.redemptionCount);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _UserBadge implements UserBadge {
  const _UserBadge(
      {required this.id,
      required this.progress,
      required this.monthYear,
      required this.badge,
      this.redeemed = false,
      this.earnedAt,
      required this.redemptionCount});
  factory _UserBadge.fromJson(Map<String, dynamic> json) =>
      _$UserBadgeFromJson(json);

  @override
  final int id;
  @override
  final int progress;
  @override
  final String monthYear;
  @override
  final Badge badge;
  @override
  @JsonKey()
  final bool redeemed;
  @override
  final String? earnedAt;
  @override
  final int redemptionCount;

  /// Create a copy of UserBadge
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserBadgeCopyWith<_UserBadge> get copyWith =>
      __$UserBadgeCopyWithImpl<_UserBadge>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserBadgeToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserBadge &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.monthYear, monthYear) ||
                other.monthYear == monthYear) &&
            (identical(other.badge, badge) || other.badge == badge) &&
            (identical(other.redeemed, redeemed) ||
                other.redeemed == redeemed) &&
            (identical(other.earnedAt, earnedAt) ||
                other.earnedAt == earnedAt) &&
            (identical(other.redemptionCount, redemptionCount) ||
                other.redemptionCount == redemptionCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, progress, monthYear, badge,
      redeemed, earnedAt, redemptionCount);

  @override
  String toString() {
    return 'UserBadge(id: $id, progress: $progress, monthYear: $monthYear, badge: $badge, redeemed: $redeemed, earnedAt: $earnedAt, redemptionCount: $redemptionCount)';
  }
}

/// @nodoc
abstract mixin class _$UserBadgeCopyWith<$Res>
    implements $UserBadgeCopyWith<$Res> {
  factory _$UserBadgeCopyWith(
          _UserBadge value, $Res Function(_UserBadge) _then) =
      __$UserBadgeCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      int progress,
      String monthYear,
      Badge badge,
      bool redeemed,
      String? earnedAt,
      int redemptionCount});

  @override
  $BadgeCopyWith<$Res> get badge;
}

/// @nodoc
class __$UserBadgeCopyWithImpl<$Res> implements _$UserBadgeCopyWith<$Res> {
  __$UserBadgeCopyWithImpl(this._self, this._then);

  final _UserBadge _self;
  final $Res Function(_UserBadge) _then;

  /// Create a copy of UserBadge
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? progress = null,
    Object? monthYear = null,
    Object? badge = null,
    Object? redeemed = null,
    Object? earnedAt = freezed,
    Object? redemptionCount = null,
  }) {
    return _then(_UserBadge(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      progress: null == progress
          ? _self.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as int,
      monthYear: null == monthYear
          ? _self.monthYear
          : monthYear // ignore: cast_nullable_to_non_nullable
              as String,
      badge: null == badge
          ? _self.badge
          : badge // ignore: cast_nullable_to_non_nullable
              as Badge,
      redeemed: null == redeemed
          ? _self.redeemed
          : redeemed // ignore: cast_nullable_to_non_nullable
              as bool,
      earnedAt: freezed == earnedAt
          ? _self.earnedAt
          : earnedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      redemptionCount: null == redemptionCount
          ? _self.redemptionCount
          : redemptionCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }

  /// Create a copy of UserBadge
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BadgeCopyWith<$Res> get badge {
    return $BadgeCopyWith<$Res>(_self.badge, (value) {
      return _then(_self.copyWith(badge: value));
    });
  }
}

// dart format on
