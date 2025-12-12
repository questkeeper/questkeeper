// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'global_quest_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GlobalQuest {
  String get id;
  String get title;
  String get description;
  int get goalValue;
  int get currentValue;
  int get participantCount;
  int get rewardPoints;
  String get startDate;
  String get endDate;
  bool get completed;

  /// Create a copy of GlobalQuest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GlobalQuestCopyWith<GlobalQuest> get copyWith =>
      _$GlobalQuestCopyWithImpl<GlobalQuest>(this as GlobalQuest, _$identity);

  /// Serializes this GlobalQuest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GlobalQuest &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.goalValue, goalValue) ||
                other.goalValue == goalValue) &&
            (identical(other.currentValue, currentValue) ||
                other.currentValue == currentValue) &&
            (identical(other.participantCount, participantCount) ||
                other.participantCount == participantCount) &&
            (identical(other.rewardPoints, rewardPoints) ||
                other.rewardPoints == rewardPoints) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.completed, completed) ||
                other.completed == completed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      goalValue,
      currentValue,
      participantCount,
      rewardPoints,
      startDate,
      endDate,
      completed);

  @override
  String toString() {
    return 'GlobalQuest(id: $id, title: $title, description: $description, goalValue: $goalValue, currentValue: $currentValue, participantCount: $participantCount, rewardPoints: $rewardPoints, startDate: $startDate, endDate: $endDate, completed: $completed)';
  }
}

/// @nodoc
abstract mixin class $GlobalQuestCopyWith<$Res> {
  factory $GlobalQuestCopyWith(
          GlobalQuest value, $Res Function(GlobalQuest) _then) =
      _$GlobalQuestCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      int goalValue,
      int currentValue,
      int participantCount,
      int rewardPoints,
      String startDate,
      String endDate,
      bool completed});
}

/// @nodoc
class _$GlobalQuestCopyWithImpl<$Res> implements $GlobalQuestCopyWith<$Res> {
  _$GlobalQuestCopyWithImpl(this._self, this._then);

  final GlobalQuest _self;
  final $Res Function(GlobalQuest) _then;

  /// Create a copy of GlobalQuest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? goalValue = null,
    Object? currentValue = null,
    Object? participantCount = null,
    Object? rewardPoints = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? completed = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      goalValue: null == goalValue
          ? _self.goalValue
          : goalValue // ignore: cast_nullable_to_non_nullable
              as int,
      currentValue: null == currentValue
          ? _self.currentValue
          : currentValue // ignore: cast_nullable_to_non_nullable
              as int,
      participantCount: null == participantCount
          ? _self.participantCount
          : participantCount // ignore: cast_nullable_to_non_nullable
              as int,
      rewardPoints: null == rewardPoints
          ? _self.rewardPoints
          : rewardPoints // ignore: cast_nullable_to_non_nullable
              as int,
      startDate: null == startDate
          ? _self.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      endDate: null == endDate
          ? _self.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String,
      completed: null == completed
          ? _self.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [GlobalQuest].
extension GlobalQuestPatterns on GlobalQuest {
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
    TResult Function(_GlobalQuest value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GlobalQuest() when $default != null:
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
    TResult Function(_GlobalQuest value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GlobalQuest():
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
    TResult? Function(_GlobalQuest value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GlobalQuest() when $default != null:
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
            String id,
            String title,
            String description,
            int goalValue,
            int currentValue,
            int participantCount,
            int rewardPoints,
            String startDate,
            String endDate,
            bool completed)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GlobalQuest() when $default != null:
        return $default(
            _that.id,
            _that.title,
            _that.description,
            _that.goalValue,
            _that.currentValue,
            _that.participantCount,
            _that.rewardPoints,
            _that.startDate,
            _that.endDate,
            _that.completed);
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
            String id,
            String title,
            String description,
            int goalValue,
            int currentValue,
            int participantCount,
            int rewardPoints,
            String startDate,
            String endDate,
            bool completed)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GlobalQuest():
        return $default(
            _that.id,
            _that.title,
            _that.description,
            _that.goalValue,
            _that.currentValue,
            _that.participantCount,
            _that.rewardPoints,
            _that.startDate,
            _that.endDate,
            _that.completed);
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
            String id,
            String title,
            String description,
            int goalValue,
            int currentValue,
            int participantCount,
            int rewardPoints,
            String startDate,
            String endDate,
            bool completed)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GlobalQuest() when $default != null:
        return $default(
            _that.id,
            _that.title,
            _that.description,
            _that.goalValue,
            _that.currentValue,
            _that.participantCount,
            _that.rewardPoints,
            _that.startDate,
            _that.endDate,
            _that.completed);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _GlobalQuest extends GlobalQuest {
  const _GlobalQuest(
      {required this.id,
      required this.title,
      required this.description,
      required this.goalValue,
      required this.currentValue,
      required this.participantCount,
      required this.rewardPoints,
      required this.startDate,
      required this.endDate,
      this.completed = false})
      : super._();
  factory _GlobalQuest.fromJson(Map<String, dynamic> json) =>
      _$GlobalQuestFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final int goalValue;
  @override
  final int currentValue;
  @override
  final int participantCount;
  @override
  final int rewardPoints;
  @override
  final String startDate;
  @override
  final String endDate;
  @override
  @JsonKey()
  final bool completed;

  /// Create a copy of GlobalQuest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GlobalQuestCopyWith<_GlobalQuest> get copyWith =>
      __$GlobalQuestCopyWithImpl<_GlobalQuest>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GlobalQuestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GlobalQuest &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.goalValue, goalValue) ||
                other.goalValue == goalValue) &&
            (identical(other.currentValue, currentValue) ||
                other.currentValue == currentValue) &&
            (identical(other.participantCount, participantCount) ||
                other.participantCount == participantCount) &&
            (identical(other.rewardPoints, rewardPoints) ||
                other.rewardPoints == rewardPoints) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.completed, completed) ||
                other.completed == completed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      goalValue,
      currentValue,
      participantCount,
      rewardPoints,
      startDate,
      endDate,
      completed);

  @override
  String toString() {
    return 'GlobalQuest(id: $id, title: $title, description: $description, goalValue: $goalValue, currentValue: $currentValue, participantCount: $participantCount, rewardPoints: $rewardPoints, startDate: $startDate, endDate: $endDate, completed: $completed)';
  }
}

/// @nodoc
abstract mixin class _$GlobalQuestCopyWith<$Res>
    implements $GlobalQuestCopyWith<$Res> {
  factory _$GlobalQuestCopyWith(
          _GlobalQuest value, $Res Function(_GlobalQuest) _then) =
      __$GlobalQuestCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      int goalValue,
      int currentValue,
      int participantCount,
      int rewardPoints,
      String startDate,
      String endDate,
      bool completed});
}

/// @nodoc
class __$GlobalQuestCopyWithImpl<$Res> implements _$GlobalQuestCopyWith<$Res> {
  __$GlobalQuestCopyWithImpl(this._self, this._then);

  final _GlobalQuest _self;
  final $Res Function(_GlobalQuest) _then;

  /// Create a copy of GlobalQuest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? goalValue = null,
    Object? currentValue = null,
    Object? participantCount = null,
    Object? rewardPoints = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? completed = null,
  }) {
    return _then(_GlobalQuest(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      goalValue: null == goalValue
          ? _self.goalValue
          : goalValue // ignore: cast_nullable_to_non_nullable
              as int,
      currentValue: null == currentValue
          ? _self.currentValue
          : currentValue // ignore: cast_nullable_to_non_nullable
              as int,
      participantCount: null == participantCount
          ? _self.participantCount
          : participantCount // ignore: cast_nullable_to_non_nullable
              as int,
      rewardPoints: null == rewardPoints
          ? _self.rewardPoints
          : rewardPoints // ignore: cast_nullable_to_non_nullable
              as int,
      startDate: null == startDate
          ? _self.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      endDate: null == endDate
          ? _self.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String,
      completed: null == completed
          ? _self.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
