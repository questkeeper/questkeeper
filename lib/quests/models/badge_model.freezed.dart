// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'badge_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Badge {
  String get id;
  String get name;
  String get description;
  int get points;
  int get requirementCount;
  String get category;
  int get tier;
  bool get resetMonthly;

  /// Create a copy of Badge
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BadgeCopyWith<Badge> get copyWith =>
      _$BadgeCopyWithImpl<Badge>(this as Badge, _$identity);

  /// Serializes this Badge to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Badge &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.points, points) || other.points == points) &&
            (identical(other.requirementCount, requirementCount) ||
                other.requirementCount == requirementCount) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.tier, tier) || other.tier == tier) &&
            (identical(other.resetMonthly, resetMonthly) ||
                other.resetMonthly == resetMonthly));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, description, points,
      requirementCount, category, tier, resetMonthly);

  @override
  String toString() {
    return 'Badge(id: $id, name: $name, description: $description, points: $points, requirementCount: $requirementCount, category: $category, tier: $tier, resetMonthly: $resetMonthly)';
  }
}

/// @nodoc
abstract mixin class $BadgeCopyWith<$Res> {
  factory $BadgeCopyWith(Badge value, $Res Function(Badge) _then) =
      _$BadgeCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      int points,
      int requirementCount,
      String category,
      int tier,
      bool resetMonthly});
}

/// @nodoc
class _$BadgeCopyWithImpl<$Res> implements $BadgeCopyWith<$Res> {
  _$BadgeCopyWithImpl(this._self, this._then);

  final Badge _self;
  final $Res Function(Badge) _then;

  /// Create a copy of Badge
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? points = null,
    Object? requirementCount = null,
    Object? category = null,
    Object? tier = null,
    Object? resetMonthly = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      points: null == points
          ? _self.points
          : points // ignore: cast_nullable_to_non_nullable
              as int,
      requirementCount: null == requirementCount
          ? _self.requirementCount
          : requirementCount // ignore: cast_nullable_to_non_nullable
              as int,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      tier: null == tier
          ? _self.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as int,
      resetMonthly: null == resetMonthly
          ? _self.resetMonthly
          : resetMonthly // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [Badge].
extension BadgePatterns on Badge {
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
    TResult Function(_Badge value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Badge() when $default != null:
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
    TResult Function(_Badge value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Badge():
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
    TResult? Function(_Badge value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Badge() when $default != null:
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
    TResult Function(String id, String name, String description, int points,
            int requirementCount, String category, int tier, bool resetMonthly)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Badge() when $default != null:
        return $default(
            _that.id,
            _that.name,
            _that.description,
            _that.points,
            _that.requirementCount,
            _that.category,
            _that.tier,
            _that.resetMonthly);
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
    TResult Function(String id, String name, String description, int points,
            int requirementCount, String category, int tier, bool resetMonthly)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Badge():
        return $default(
            _that.id,
            _that.name,
            _that.description,
            _that.points,
            _that.requirementCount,
            _that.category,
            _that.tier,
            _that.resetMonthly);
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
    TResult? Function(String id, String name, String description, int points,
            int requirementCount, String category, int tier, bool resetMonthly)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Badge() when $default != null:
        return $default(
            _that.id,
            _that.name,
            _that.description,
            _that.points,
            _that.requirementCount,
            _that.category,
            _that.tier,
            _that.resetMonthly);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Badge implements Badge {
  const _Badge(
      {required this.id,
      required this.name,
      required this.description,
      required this.points,
      required this.requirementCount,
      required this.category,
      required this.tier,
      required this.resetMonthly});
  factory _Badge.fromJson(Map<String, dynamic> json) => _$BadgeFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final int points;
  @override
  final int requirementCount;
  @override
  final String category;
  @override
  final int tier;
  @override
  final bool resetMonthly;

  /// Create a copy of Badge
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BadgeCopyWith<_Badge> get copyWith =>
      __$BadgeCopyWithImpl<_Badge>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BadgeToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Badge &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.points, points) || other.points == points) &&
            (identical(other.requirementCount, requirementCount) ||
                other.requirementCount == requirementCount) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.tier, tier) || other.tier == tier) &&
            (identical(other.resetMonthly, resetMonthly) ||
                other.resetMonthly == resetMonthly));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, description, points,
      requirementCount, category, tier, resetMonthly);

  @override
  String toString() {
    return 'Badge(id: $id, name: $name, description: $description, points: $points, requirementCount: $requirementCount, category: $category, tier: $tier, resetMonthly: $resetMonthly)';
  }
}

/// @nodoc
abstract mixin class _$BadgeCopyWith<$Res> implements $BadgeCopyWith<$Res> {
  factory _$BadgeCopyWith(_Badge value, $Res Function(_Badge) _then) =
      __$BadgeCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      int points,
      int requirementCount,
      String category,
      int tier,
      bool resetMonthly});
}

/// @nodoc
class __$BadgeCopyWithImpl<$Res> implements _$BadgeCopyWith<$Res> {
  __$BadgeCopyWithImpl(this._self, this._then);

  final _Badge _self;
  final $Res Function(_Badge) _then;

  /// Create a copy of Badge
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? points = null,
    Object? requirementCount = null,
    Object? category = null,
    Object? tier = null,
    Object? resetMonthly = null,
  }) {
    return _then(_Badge(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      points: null == points
          ? _self.points
          : points // ignore: cast_nullable_to_non_nullable
              as int,
      requirementCount: null == requirementCount
          ? _self.requirementCount
          : requirementCount // ignore: cast_nullable_to_non_nullable
              as int,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      tier: null == tier
          ? _self.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as int,
      resetMonthly: null == resetMonthly
          ? _self.resetMonthly
          : resetMonthly // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
