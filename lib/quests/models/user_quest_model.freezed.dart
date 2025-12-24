// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_quest_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserQuest {
  int get id;
  Quest get quest;
  int get progress;
  bool get completed;
  bool get redeemed;
  String? get completedAt;
  String get assignedAt;

  /// Create a copy of UserQuest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserQuestCopyWith<UserQuest> get copyWith =>
      _$UserQuestCopyWithImpl<UserQuest>(this as UserQuest, _$identity);

  /// Serializes this UserQuest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserQuest &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.quest, quest) || other.quest == quest) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.redeemed, redeemed) ||
                other.redeemed == redeemed) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.assignedAt, assignedAt) ||
                other.assignedAt == assignedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, quest, progress, completed,
      redeemed, completedAt, assignedAt);

  @override
  String toString() {
    return 'UserQuest(id: $id, quest: $quest, progress: $progress, completed: $completed, redeemed: $redeemed, completedAt: $completedAt, assignedAt: $assignedAt)';
  }
}

/// @nodoc
abstract mixin class $UserQuestCopyWith<$Res> {
  factory $UserQuestCopyWith(UserQuest value, $Res Function(UserQuest) _then) =
      _$UserQuestCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      Quest quest,
      int progress,
      bool completed,
      bool redeemed,
      String? completedAt,
      String assignedAt});

  $QuestCopyWith<$Res> get quest;
}

/// @nodoc
class _$UserQuestCopyWithImpl<$Res> implements $UserQuestCopyWith<$Res> {
  _$UserQuestCopyWithImpl(this._self, this._then);

  final UserQuest _self;
  final $Res Function(UserQuest) _then;

  /// Create a copy of UserQuest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quest = null,
    Object? progress = null,
    Object? completed = null,
    Object? redeemed = null,
    Object? completedAt = freezed,
    Object? assignedAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      quest: null == quest
          ? _self.quest
          : quest // ignore: cast_nullable_to_non_nullable
              as Quest,
      progress: null == progress
          ? _self.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as int,
      completed: null == completed
          ? _self.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool,
      redeemed: null == redeemed
          ? _self.redeemed
          : redeemed // ignore: cast_nullable_to_non_nullable
              as bool,
      completedAt: freezed == completedAt
          ? _self.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedAt: null == assignedAt
          ? _self.assignedAt
          : assignedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  /// Create a copy of UserQuest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $QuestCopyWith<$Res> get quest {
    return $QuestCopyWith<$Res>(_self.quest, (value) {
      return _then(_self.copyWith(quest: value));
    });
  }
}

/// Adds pattern-matching-related methods to [UserQuest].
extension UserQuestPatterns on UserQuest {
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
    TResult Function(_UserQuest value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserQuest() when $default != null:
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
    TResult Function(_UserQuest value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserQuest():
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
    TResult? Function(_UserQuest value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserQuest() when $default != null:
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
    TResult Function(int id, Quest quest, int progress, bool completed,
            bool redeemed, String? completedAt, String assignedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserQuest() when $default != null:
        return $default(_that.id, _that.quest, _that.progress, _that.completed,
            _that.redeemed, _that.completedAt, _that.assignedAt);
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
    TResult Function(int id, Quest quest, int progress, bool completed,
            bool redeemed, String? completedAt, String assignedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserQuest():
        return $default(_that.id, _that.quest, _that.progress, _that.completed,
            _that.redeemed, _that.completedAt, _that.assignedAt);
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
    TResult? Function(int id, Quest quest, int progress, bool completed,
            bool redeemed, String? completedAt, String assignedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserQuest() when $default != null:
        return $default(_that.id, _that.quest, _that.progress, _that.completed,
            _that.redeemed, _that.completedAt, _that.assignedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _UserQuest implements UserQuest {
  const _UserQuest(
      {required this.id,
      required this.quest,
      required this.progress,
      this.completed = false,
      this.redeemed = false,
      this.completedAt,
      required this.assignedAt});
  factory _UserQuest.fromJson(Map<String, dynamic> json) =>
      _$UserQuestFromJson(json);

  @override
  final int id;
  @override
  final Quest quest;
  @override
  final int progress;
  @override
  @JsonKey()
  final bool completed;
  @override
  @JsonKey()
  final bool redeemed;
  @override
  final String? completedAt;
  @override
  final String assignedAt;

  /// Create a copy of UserQuest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserQuestCopyWith<_UserQuest> get copyWith =>
      __$UserQuestCopyWithImpl<_UserQuest>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserQuestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserQuest &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.quest, quest) || other.quest == quest) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.redeemed, redeemed) ||
                other.redeemed == redeemed) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.assignedAt, assignedAt) ||
                other.assignedAt == assignedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, quest, progress, completed,
      redeemed, completedAt, assignedAt);

  @override
  String toString() {
    return 'UserQuest(id: $id, quest: $quest, progress: $progress, completed: $completed, redeemed: $redeemed, completedAt: $completedAt, assignedAt: $assignedAt)';
  }
}

/// @nodoc
abstract mixin class _$UserQuestCopyWith<$Res>
    implements $UserQuestCopyWith<$Res> {
  factory _$UserQuestCopyWith(
          _UserQuest value, $Res Function(_UserQuest) _then) =
      __$UserQuestCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      Quest quest,
      int progress,
      bool completed,
      bool redeemed,
      String? completedAt,
      String assignedAt});

  @override
  $QuestCopyWith<$Res> get quest;
}

/// @nodoc
class __$UserQuestCopyWithImpl<$Res> implements _$UserQuestCopyWith<$Res> {
  __$UserQuestCopyWithImpl(this._self, this._then);

  final _UserQuest _self;
  final $Res Function(_UserQuest) _then;

  /// Create a copy of UserQuest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? quest = null,
    Object? progress = null,
    Object? completed = null,
    Object? redeemed = null,
    Object? completedAt = freezed,
    Object? assignedAt = null,
  }) {
    return _then(_UserQuest(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      quest: null == quest
          ? _self.quest
          : quest // ignore: cast_nullable_to_non_nullable
              as Quest,
      progress: null == progress
          ? _self.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as int,
      completed: null == completed
          ? _self.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool,
      redeemed: null == redeemed
          ? _self.redeemed
          : redeemed // ignore: cast_nullable_to_non_nullable
              as bool,
      completedAt: freezed == completedAt
          ? _self.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedAt: null == assignedAt
          ? _self.assignedAt
          : assignedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  /// Create a copy of UserQuest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $QuestCopyWith<$Res> get quest {
    return $QuestCopyWith<$Res>(_self.quest, (value) {
      return _then(_self.copyWith(quest: value));
    });
  }
}

// dart format on
