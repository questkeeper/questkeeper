// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Profile {
  String get user_id;
  String get username;
  String get created_at;
  String get updated_at;
  int get points;
  bool get isActive;
  bool get isPublic;
  bool? get isPro;

  /// Create a copy of Profile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProfileCopyWith<Profile> get copyWith =>
      _$ProfileCopyWithImpl<Profile>(this as Profile, _$identity);

  /// Serializes this Profile to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Profile &&
            (identical(other.user_id, user_id) || other.user_id == user_id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.created_at, created_at) ||
                other.created_at == created_at) &&
            (identical(other.updated_at, updated_at) ||
                other.updated_at == updated_at) &&
            (identical(other.points, points) || other.points == points) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic) &&
            (identical(other.isPro, isPro) || other.isPro == isPro));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, user_id, username, created_at,
      updated_at, points, isActive, isPublic, isPro);

  @override
  String toString() {
    return 'Profile(user_id: $user_id, username: $username, created_at: $created_at, updated_at: $updated_at, points: $points, isActive: $isActive, isPublic: $isPublic, isPro: $isPro)';
  }
}

/// @nodoc
abstract mixin class $ProfileCopyWith<$Res> {
  factory $ProfileCopyWith(Profile value, $Res Function(Profile) _then) =
      _$ProfileCopyWithImpl;
  @useResult
  $Res call(
      {String user_id,
      String username,
      String created_at,
      String updated_at,
      int points,
      bool isActive,
      bool isPublic,
      bool? isPro});
}

/// @nodoc
class _$ProfileCopyWithImpl<$Res> implements $ProfileCopyWith<$Res> {
  _$ProfileCopyWithImpl(this._self, this._then);

  final Profile _self;
  final $Res Function(Profile) _then;

  /// Create a copy of Profile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user_id = null,
    Object? username = null,
    Object? created_at = null,
    Object? updated_at = null,
    Object? points = null,
    Object? isActive = null,
    Object? isPublic = null,
    Object? isPro = freezed,
  }) {
    return _then(_self.copyWith(
      user_id: null == user_id
          ? _self.user_id
          : user_id // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _self.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      created_at: null == created_at
          ? _self.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as String,
      updated_at: null == updated_at
          ? _self.updated_at
          : updated_at // ignore: cast_nullable_to_non_nullable
              as String,
      points: null == points
          ? _self.points
          : points // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isPublic: null == isPublic
          ? _self.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      isPro: freezed == isPro
          ? _self.isPro
          : isPro // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// Adds pattern-matching-related methods to [Profile].
extension ProfilePatterns on Profile {
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
    TResult Function(_Profile value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Profile() when $default != null:
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
    TResult Function(_Profile value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Profile():
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
    TResult? Function(_Profile value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Profile() when $default != null:
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
    TResult Function(
            String user_id,
            String username,
            String created_at,
            String updated_at,
            int points,
            bool isActive,
            bool isPublic,
            bool? isPro)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Profile() when $default != null:
        return $default(
            _that.user_id,
            _that.username,
            _that.created_at,
            _that.updated_at,
            _that.points,
            _that.isActive,
            _that.isPublic,
            _that.isPro);
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
    TResult Function(
            String user_id,
            String username,
            String created_at,
            String updated_at,
            int points,
            bool isActive,
            bool isPublic,
            bool? isPro)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Profile():
        return $default(
            _that.user_id,
            _that.username,
            _that.created_at,
            _that.updated_at,
            _that.points,
            _that.isActive,
            _that.isPublic,
            _that.isPro);
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
            String user_id,
            String username,
            String created_at,
            String updated_at,
            int points,
            bool isActive,
            bool isPublic,
            bool? isPro)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Profile() when $default != null:
        return $default(
            _that.user_id,
            _that.username,
            _that.created_at,
            _that.updated_at,
            _that.points,
            _that.isActive,
            _that.isPublic,
            _that.isPro);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Profile implements Profile {
  const _Profile(
      {required this.user_id,
      required this.username,
      required this.created_at,
      required this.updated_at,
      required this.points,
      required this.isActive,
      required this.isPublic,
      this.isPro});
  factory _Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

  @override
  final String user_id;
  @override
  final String username;
  @override
  final String created_at;
  @override
  final String updated_at;
  @override
  final int points;
  @override
  final bool isActive;
  @override
  final bool isPublic;
  @override
  final bool? isPro;

  /// Create a copy of Profile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProfileCopyWith<_Profile> get copyWith =>
      __$ProfileCopyWithImpl<_Profile>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ProfileToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Profile &&
            (identical(other.user_id, user_id) || other.user_id == user_id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.created_at, created_at) ||
                other.created_at == created_at) &&
            (identical(other.updated_at, updated_at) ||
                other.updated_at == updated_at) &&
            (identical(other.points, points) || other.points == points) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic) &&
            (identical(other.isPro, isPro) || other.isPro == isPro));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, user_id, username, created_at,
      updated_at, points, isActive, isPublic, isPro);

  @override
  String toString() {
    return 'Profile(user_id: $user_id, username: $username, created_at: $created_at, updated_at: $updated_at, points: $points, isActive: $isActive, isPublic: $isPublic, isPro: $isPro)';
  }
}

/// @nodoc
abstract mixin class _$ProfileCopyWith<$Res> implements $ProfileCopyWith<$Res> {
  factory _$ProfileCopyWith(_Profile value, $Res Function(_Profile) _then) =
      __$ProfileCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String user_id,
      String username,
      String created_at,
      String updated_at,
      int points,
      bool isActive,
      bool isPublic,
      bool? isPro});
}

/// @nodoc
class __$ProfileCopyWithImpl<$Res> implements _$ProfileCopyWith<$Res> {
  __$ProfileCopyWithImpl(this._self, this._then);

  final _Profile _self;
  final $Res Function(_Profile) _then;

  /// Create a copy of Profile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? user_id = null,
    Object? username = null,
    Object? created_at = null,
    Object? updated_at = null,
    Object? points = null,
    Object? isActive = null,
    Object? isPublic = null,
    Object? isPro = freezed,
  }) {
    return _then(_Profile(
      user_id: null == user_id
          ? _self.user_id
          : user_id // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _self.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      created_at: null == created_at
          ? _self.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as String,
      updated_at: null == updated_at
          ? _self.updated_at
          : updated_at // ignore: cast_nullable_to_non_nullable
              as String,
      points: null == points
          ? _self.points
          : points // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isPublic: null == isPublic
          ? _self.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      isPro: freezed == isPro
          ? _self.isPro
          : isPro // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

// dart format on
