// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'categories_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Categories {
  int? get id;
  String get title;
  DateTime? get createdAt;
  DateTime? get updatedAt;
  String? get color;
  int? get spaceId;
  bool get archived;
  List<Tasks>? get tasks;

  /// Create a copy of Categories
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CategoriesCopyWith<Categories> get copyWith =>
      _$CategoriesCopyWithImpl<Categories>(this as Categories, _$identity);

  /// Serializes this Categories to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Categories &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.spaceId, spaceId) || other.spaceId == spaceId) &&
            (identical(other.archived, archived) ||
                other.archived == archived) &&
            const DeepCollectionEquality().equals(other.tasks, tasks));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, createdAt, updatedAt,
      color, spaceId, archived, const DeepCollectionEquality().hash(tasks));

  @override
  String toString() {
    return 'Categories(id: $id, title: $title, createdAt: $createdAt, updatedAt: $updatedAt, color: $color, spaceId: $spaceId, archived: $archived, tasks: $tasks)';
  }
}

/// @nodoc
abstract mixin class $CategoriesCopyWith<$Res> {
  factory $CategoriesCopyWith(
          Categories value, $Res Function(Categories) _then) =
      _$CategoriesCopyWithImpl;
  @useResult
  $Res call(
      {int? id,
      String title,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? color,
      int? spaceId,
      bool archived,
      List<Tasks>? tasks});
}

/// @nodoc
class _$CategoriesCopyWithImpl<$Res> implements $CategoriesCopyWith<$Res> {
  _$CategoriesCopyWithImpl(this._self, this._then);

  final Categories _self;
  final $Res Function(Categories) _then;

  /// Create a copy of Categories
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? color = freezed,
    Object? spaceId = freezed,
    Object? archived = null,
    Object? tasks = freezed,
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
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      color: freezed == color
          ? _self.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      spaceId: freezed == spaceId
          ? _self.spaceId
          : spaceId // ignore: cast_nullable_to_non_nullable
              as int?,
      archived: null == archived
          ? _self.archived
          : archived // ignore: cast_nullable_to_non_nullable
              as bool,
      tasks: freezed == tasks
          ? _self.tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as List<Tasks>?,
    ));
  }
}

/// Adds pattern-matching-related methods to [Categories].
extension CategoriesPatterns on Categories {
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
    TResult Function(_Categories value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Categories() when $default != null:
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
    TResult Function(_Categories value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Categories():
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
    TResult? Function(_Categories value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Categories() when $default != null:
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
            String title,
            DateTime? createdAt,
            DateTime? updatedAt,
            String? color,
            int? spaceId,
            bool archived,
            List<Tasks>? tasks)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Categories() when $default != null:
        return $default(_that.id, _that.title, _that.createdAt, _that.updatedAt,
            _that.color, _that.spaceId, _that.archived, _that.tasks);
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
            String title,
            DateTime? createdAt,
            DateTime? updatedAt,
            String? color,
            int? spaceId,
            bool archived,
            List<Tasks>? tasks)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Categories():
        return $default(_that.id, _that.title, _that.createdAt, _that.updatedAt,
            _that.color, _that.spaceId, _that.archived, _that.tasks);
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
            String title,
            DateTime? createdAt,
            DateTime? updatedAt,
            String? color,
            int? spaceId,
            bool archived,
            List<Tasks>? tasks)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Categories() when $default != null:
        return $default(_that.id, _that.title, _that.createdAt, _that.updatedAt,
            _that.color, _that.spaceId, _that.archived, _that.tasks);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Categories implements Categories {
  const _Categories(
      {this.id,
      required this.title,
      this.createdAt,
      this.updatedAt,
      this.color,
      this.spaceId,
      this.archived = false,
      final List<Tasks>? tasks})
      : _tasks = tasks;
  factory _Categories.fromJson(Map<String, dynamic> json) =>
      _$CategoriesFromJson(json);

  @override
  final int? id;
  @override
  final String title;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final String? color;
  @override
  final int? spaceId;
  @override
  @JsonKey()
  final bool archived;
  final List<Tasks>? _tasks;
  @override
  List<Tasks>? get tasks {
    final value = _tasks;
    if (value == null) return null;
    if (_tasks is EqualUnmodifiableListView) return _tasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Create a copy of Categories
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CategoriesCopyWith<_Categories> get copyWith =>
      __$CategoriesCopyWithImpl<_Categories>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CategoriesToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Categories &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.spaceId, spaceId) || other.spaceId == spaceId) &&
            (identical(other.archived, archived) ||
                other.archived == archived) &&
            const DeepCollectionEquality().equals(other._tasks, _tasks));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, createdAt, updatedAt,
      color, spaceId, archived, const DeepCollectionEquality().hash(_tasks));

  @override
  String toString() {
    return 'Categories(id: $id, title: $title, createdAt: $createdAt, updatedAt: $updatedAt, color: $color, spaceId: $spaceId, archived: $archived, tasks: $tasks)';
  }
}

/// @nodoc
abstract mixin class _$CategoriesCopyWith<$Res>
    implements $CategoriesCopyWith<$Res> {
  factory _$CategoriesCopyWith(
          _Categories value, $Res Function(_Categories) _then) =
      __$CategoriesCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? id,
      String title,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? color,
      int? spaceId,
      bool archived,
      List<Tasks>? tasks});
}

/// @nodoc
class __$CategoriesCopyWithImpl<$Res> implements _$CategoriesCopyWith<$Res> {
  __$CategoriesCopyWithImpl(this._self, this._then);

  final _Categories _self;
  final $Res Function(_Categories) _then;

  /// Create a copy of Categories
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? title = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? color = freezed,
    Object? spaceId = freezed,
    Object? archived = null,
    Object? tasks = freezed,
  }) {
    return _then(_Categories(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      color: freezed == color
          ? _self.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      spaceId: freezed == spaceId
          ? _self.spaceId
          : spaceId // ignore: cast_nullable_to_non_nullable
              as int?,
      archived: null == archived
          ? _self.archived
          : archived // ignore: cast_nullable_to_non_nullable
              as bool,
      tasks: freezed == tasks
          ? _self._tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as List<Tasks>?,
    ));
  }
}

// dart format on
