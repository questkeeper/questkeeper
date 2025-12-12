// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tasks_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Tasks {
  int? get id;
  DateTime? get createdAt;
  DateTime? get updatedAt;
  String get title;
  DateTime get dueDate;
  int? get categoryId;
  int? get spaceId;
  String? get description;
  bool get completed;
  bool get starred;

  /// Create a copy of Tasks
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TasksCopyWith<Tasks> get copyWith =>
      _$TasksCopyWithImpl<Tasks>(this as Tasks, _$identity);

  /// Serializes this Tasks to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Tasks &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.spaceId, spaceId) || other.spaceId == spaceId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.starred, starred) || other.starred == starred));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, createdAt, updatedAt, title,
      dueDate, categoryId, spaceId, description, completed, starred);

  @override
  String toString() {
    return 'Tasks(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, title: $title, dueDate: $dueDate, categoryId: $categoryId, spaceId: $spaceId, description: $description, completed: $completed, starred: $starred)';
  }
}

/// @nodoc
abstract mixin class $TasksCopyWith<$Res> {
  factory $TasksCopyWith(Tasks value, $Res Function(Tasks) _then) =
      _$TasksCopyWithImpl;
  @useResult
  $Res call(
      {int? id,
      DateTime? createdAt,
      DateTime? updatedAt,
      String title,
      DateTime dueDate,
      int? categoryId,
      int? spaceId,
      String? description,
      bool completed,
      bool starred});
}

/// @nodoc
class _$TasksCopyWithImpl<$Res> implements $TasksCopyWith<$Res> {
  _$TasksCopyWithImpl(this._self, this._then);

  final Tasks _self;
  final $Res Function(Tasks) _then;

  /// Create a copy of Tasks
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? title = null,
    Object? dueDate = null,
    Object? categoryId = freezed,
    Object? spaceId = freezed,
    Object? description = freezed,
    Object? completed = null,
    Object? starred = null,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      dueDate: null == dueDate
          ? _self.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      categoryId: freezed == categoryId
          ? _self.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int?,
      spaceId: freezed == spaceId
          ? _self.spaceId
          : spaceId // ignore: cast_nullable_to_non_nullable
              as int?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      completed: null == completed
          ? _self.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool,
      starred: null == starred
          ? _self.starred
          : starred // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [Tasks].
extension TasksPatterns on Tasks {
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
    TResult Function(_Tasks value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Tasks() when $default != null:
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
    TResult Function(_Tasks value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Tasks():
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
    TResult? Function(_Tasks value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Tasks() when $default != null:
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
            int? id,
            DateTime? createdAt,
            DateTime? updatedAt,
            String title,
            DateTime dueDate,
            int? categoryId,
            int? spaceId,
            String? description,
            bool completed,
            bool starred)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Tasks() when $default != null:
        return $default(
            _that.id,
            _that.createdAt,
            _that.updatedAt,
            _that.title,
            _that.dueDate,
            _that.categoryId,
            _that.spaceId,
            _that.description,
            _that.completed,
            _that.starred);
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
            int? id,
            DateTime? createdAt,
            DateTime? updatedAt,
            String title,
            DateTime dueDate,
            int? categoryId,
            int? spaceId,
            String? description,
            bool completed,
            bool starred)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Tasks():
        return $default(
            _that.id,
            _that.createdAt,
            _that.updatedAt,
            _that.title,
            _that.dueDate,
            _that.categoryId,
            _that.spaceId,
            _that.description,
            _that.completed,
            _that.starred);
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
            int? id,
            DateTime? createdAt,
            DateTime? updatedAt,
            String title,
            DateTime dueDate,
            int? categoryId,
            int? spaceId,
            String? description,
            bool completed,
            bool starred)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Tasks() when $default != null:
        return $default(
            _that.id,
            _that.createdAt,
            _that.updatedAt,
            _that.title,
            _that.dueDate,
            _that.categoryId,
            _that.spaceId,
            _that.description,
            _that.completed,
            _that.starred);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Tasks implements Tasks {
  const _Tasks(
      {this.id,
      this.createdAt,
      this.updatedAt,
      required this.title,
      required this.dueDate,
      this.categoryId,
      this.spaceId,
      this.description,
      this.completed = false,
      this.starred = false});
  factory _Tasks.fromJson(Map<String, dynamic> json) => _$TasksFromJson(json);

  @override
  final int? id;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final String title;
  @override
  final DateTime dueDate;
  @override
  final int? categoryId;
  @override
  final int? spaceId;
  @override
  final String? description;
  @override
  @JsonKey()
  final bool completed;
  @override
  @JsonKey()
  final bool starred;

  /// Create a copy of Tasks
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TasksCopyWith<_Tasks> get copyWith =>
      __$TasksCopyWithImpl<_Tasks>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TasksToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Tasks &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.spaceId, spaceId) || other.spaceId == spaceId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.starred, starred) || other.starred == starred));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, createdAt, updatedAt, title,
      dueDate, categoryId, spaceId, description, completed, starred);

  @override
  String toString() {
    return 'Tasks(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, title: $title, dueDate: $dueDate, categoryId: $categoryId, spaceId: $spaceId, description: $description, completed: $completed, starred: $starred)';
  }
}

/// @nodoc
abstract mixin class _$TasksCopyWith<$Res> implements $TasksCopyWith<$Res> {
  factory _$TasksCopyWith(_Tasks value, $Res Function(_Tasks) _then) =
      __$TasksCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? id,
      DateTime? createdAt,
      DateTime? updatedAt,
      String title,
      DateTime dueDate,
      int? categoryId,
      int? spaceId,
      String? description,
      bool completed,
      bool starred});
}

/// @nodoc
class __$TasksCopyWithImpl<$Res> implements _$TasksCopyWith<$Res> {
  __$TasksCopyWithImpl(this._self, this._then);

  final _Tasks _self;
  final $Res Function(_Tasks) _then;

  /// Create a copy of Tasks
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? title = null,
    Object? dueDate = null,
    Object? categoryId = freezed,
    Object? spaceId = freezed,
    Object? description = freezed,
    Object? completed = null,
    Object? starred = null,
  }) {
    return _then(_Tasks(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      dueDate: null == dueDate
          ? _self.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      categoryId: freezed == categoryId
          ? _self.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int?,
      spaceId: freezed == spaceId
          ? _self.spaceId
          : spaceId // ignore: cast_nullable_to_non_nullable
              as int?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      completed: null == completed
          ? _self.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool,
      starred: null == starred
          ? _self.starred
          : starred // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
