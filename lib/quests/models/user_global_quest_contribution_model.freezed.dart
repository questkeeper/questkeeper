// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_global_quest_contribution_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserGlobalQuestContribution {
  int get id;
  String get globalQuestId;
  int get contributionValue;
  String get lastContributedAt;

  /// Create a copy of UserGlobalQuestContribution
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserGlobalQuestContributionCopyWith<UserGlobalQuestContribution>
      get copyWith => _$UserGlobalQuestContributionCopyWithImpl<
              UserGlobalQuestContribution>(
          this as UserGlobalQuestContribution, _$identity);

  /// Serializes this UserGlobalQuestContribution to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserGlobalQuestContribution &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.globalQuestId, globalQuestId) ||
                other.globalQuestId == globalQuestId) &&
            (identical(other.contributionValue, contributionValue) ||
                other.contributionValue == contributionValue) &&
            (identical(other.lastContributedAt, lastContributedAt) ||
                other.lastContributedAt == lastContributedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, globalQuestId, contributionValue, lastContributedAt);

  @override
  String toString() {
    return 'UserGlobalQuestContribution(id: $id, globalQuestId: $globalQuestId, contributionValue: $contributionValue, lastContributedAt: $lastContributedAt)';
  }
}

/// @nodoc
abstract mixin class $UserGlobalQuestContributionCopyWith<$Res> {
  factory $UserGlobalQuestContributionCopyWith(
          UserGlobalQuestContribution value,
          $Res Function(UserGlobalQuestContribution) _then) =
      _$UserGlobalQuestContributionCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      String globalQuestId,
      int contributionValue,
      String lastContributedAt});
}

/// @nodoc
class _$UserGlobalQuestContributionCopyWithImpl<$Res>
    implements $UserGlobalQuestContributionCopyWith<$Res> {
  _$UserGlobalQuestContributionCopyWithImpl(this._self, this._then);

  final UserGlobalQuestContribution _self;
  final $Res Function(UserGlobalQuestContribution) _then;

  /// Create a copy of UserGlobalQuestContribution
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? globalQuestId = null,
    Object? contributionValue = null,
    Object? lastContributedAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      globalQuestId: null == globalQuestId
          ? _self.globalQuestId
          : globalQuestId // ignore: cast_nullable_to_non_nullable
              as String,
      contributionValue: null == contributionValue
          ? _self.contributionValue
          : contributionValue // ignore: cast_nullable_to_non_nullable
              as int,
      lastContributedAt: null == lastContributedAt
          ? _self.lastContributedAt
          : lastContributedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [UserGlobalQuestContribution].
extension UserGlobalQuestContributionPatterns on UserGlobalQuestContribution {
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
    TResult Function(_UserGlobalQuestContribution value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserGlobalQuestContribution() when $default != null:
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
    TResult Function(_UserGlobalQuestContribution value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserGlobalQuestContribution():
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
    TResult? Function(_UserGlobalQuestContribution value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserGlobalQuestContribution() when $default != null:
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
    TResult Function(int id, String globalQuestId, int contributionValue,
            String lastContributedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserGlobalQuestContribution() when $default != null:
        return $default(_that.id, _that.globalQuestId, _that.contributionValue,
            _that.lastContributedAt);
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
    TResult Function(int id, String globalQuestId, int contributionValue,
            String lastContributedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserGlobalQuestContribution():
        return $default(_that.id, _that.globalQuestId, _that.contributionValue,
            _that.lastContributedAt);
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
    TResult? Function(int id, String globalQuestId, int contributionValue,
            String lastContributedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserGlobalQuestContribution() when $default != null:
        return $default(_that.id, _that.globalQuestId, _that.contributionValue,
            _that.lastContributedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _UserGlobalQuestContribution implements UserGlobalQuestContribution {
  const _UserGlobalQuestContribution(
      {required this.id,
      required this.globalQuestId,
      required this.contributionValue,
      required this.lastContributedAt});
  factory _UserGlobalQuestContribution.fromJson(Map<String, dynamic> json) =>
      _$UserGlobalQuestContributionFromJson(json);

  @override
  final int id;
  @override
  final String globalQuestId;
  @override
  final int contributionValue;
  @override
  final String lastContributedAt;

  /// Create a copy of UserGlobalQuestContribution
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserGlobalQuestContributionCopyWith<_UserGlobalQuestContribution>
      get copyWith => __$UserGlobalQuestContributionCopyWithImpl<
          _UserGlobalQuestContribution>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserGlobalQuestContributionToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserGlobalQuestContribution &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.globalQuestId, globalQuestId) ||
                other.globalQuestId == globalQuestId) &&
            (identical(other.contributionValue, contributionValue) ||
                other.contributionValue == contributionValue) &&
            (identical(other.lastContributedAt, lastContributedAt) ||
                other.lastContributedAt == lastContributedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, globalQuestId, contributionValue, lastContributedAt);

  @override
  String toString() {
    return 'UserGlobalQuestContribution(id: $id, globalQuestId: $globalQuestId, contributionValue: $contributionValue, lastContributedAt: $lastContributedAt)';
  }
}

/// @nodoc
abstract mixin class _$UserGlobalQuestContributionCopyWith<$Res>
    implements $UserGlobalQuestContributionCopyWith<$Res> {
  factory _$UserGlobalQuestContributionCopyWith(
          _UserGlobalQuestContribution value,
          $Res Function(_UserGlobalQuestContribution) _then) =
      __$UserGlobalQuestContributionCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      String globalQuestId,
      int contributionValue,
      String lastContributedAt});
}

/// @nodoc
class __$UserGlobalQuestContributionCopyWithImpl<$Res>
    implements _$UserGlobalQuestContributionCopyWith<$Res> {
  __$UserGlobalQuestContributionCopyWithImpl(this._self, this._then);

  final _UserGlobalQuestContribution _self;
  final $Res Function(_UserGlobalQuestContribution) _then;

  /// Create a copy of UserGlobalQuestContribution
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? globalQuestId = null,
    Object? contributionValue = null,
    Object? lastContributedAt = null,
  }) {
    return _then(_UserGlobalQuestContribution(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      globalQuestId: null == globalQuestId
          ? _self.globalQuestId
          : globalQuestId // ignore: cast_nullable_to_non_nullable
              as String,
      contributionValue: null == contributionValue
          ? _self.contributionValue
          : contributionValue // ignore: cast_nullable_to_non_nullable
              as int,
      lastContributedAt: null == lastContributedAt
          ? _self.lastContributedAt
          : lastContributedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
