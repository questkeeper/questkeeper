// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'spaces_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Spaces _$SpacesFromJson(Map<String, dynamic> json) {
  return _Spaces.fromJson(json);
}

/// @nodoc
mixin _$Spaces {
  int? get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  List<Tasks>? get tasks => throw _privateConstructorUsedError;
  List<Categories>? get categories => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SpacesCopyWith<Spaces> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpacesCopyWith<$Res> {
  factory $SpacesCopyWith(Spaces value, $Res Function(Spaces) then) =
      _$SpacesCopyWithImpl<$Res, Spaces>;
  @useResult
  $Res call(
      {int? id,
      String title,
      DateTime? updatedAt,
      String? color,
      List<Tasks>? tasks,
      List<Categories>? categories});
}

/// @nodoc
class _$SpacesCopyWithImpl<$Res, $Val extends Spaces>
    implements $SpacesCopyWith<$Res> {
  _$SpacesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = null,
    Object? updatedAt = freezed,
    Object? color = freezed,
    Object? tasks = freezed,
    Object? categories = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      tasks: freezed == tasks
          ? _value.tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as List<Tasks>?,
      categories: freezed == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Categories>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpacesImplCopyWith<$Res> implements $SpacesCopyWith<$Res> {
  factory _$$SpacesImplCopyWith(
          _$SpacesImpl value, $Res Function(_$SpacesImpl) then) =
      __$$SpacesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String title,
      DateTime? updatedAt,
      String? color,
      List<Tasks>? tasks,
      List<Categories>? categories});
}

/// @nodoc
class __$$SpacesImplCopyWithImpl<$Res>
    extends _$SpacesCopyWithImpl<$Res, _$SpacesImpl>
    implements _$$SpacesImplCopyWith<$Res> {
  __$$SpacesImplCopyWithImpl(
      _$SpacesImpl _value, $Res Function(_$SpacesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = null,
    Object? updatedAt = freezed,
    Object? color = freezed,
    Object? tasks = freezed,
    Object? categories = freezed,
  }) {
    return _then(_$SpacesImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      tasks: freezed == tasks
          ? _value._tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as List<Tasks>?,
      categories: freezed == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Categories>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpacesImpl implements _Spaces {
  const _$SpacesImpl(
      {this.id,
      required this.title,
      this.updatedAt,
      this.color,
      final List<Tasks>? tasks,
      final List<Categories>? categories})
      : _tasks = tasks,
        _categories = categories;

  factory _$SpacesImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpacesImplFromJson(json);

  @override
  final int? id;
  @override
  final String title;
  @override
  final DateTime? updatedAt;
  @override
  final String? color;
  final List<Tasks>? _tasks;
  @override
  List<Tasks>? get tasks {
    final value = _tasks;
    if (value == null) return null;
    if (_tasks is EqualUnmodifiableListView) return _tasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Categories>? _categories;
  @override
  List<Categories>? get categories {
    final value = _categories;
    if (value == null) return null;
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Spaces(id: $id, title: $title, updatedAt: $updatedAt, color: $color, tasks: $tasks, categories: $categories)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpacesImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.color, color) || other.color == color) &&
            const DeepCollectionEquality().equals(other._tasks, _tasks) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      updatedAt,
      color,
      const DeepCollectionEquality().hash(_tasks),
      const DeepCollectionEquality().hash(_categories));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SpacesImplCopyWith<_$SpacesImpl> get copyWith =>
      __$$SpacesImplCopyWithImpl<_$SpacesImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpacesImplToJson(
      this,
    );
  }
}

abstract class _Spaces implements Spaces {
  const factory _Spaces(
      {final int? id,
      required final String title,
      final DateTime? updatedAt,
      final String? color,
      final List<Tasks>? tasks,
      final List<Categories>? categories}) = _$SpacesImpl;

  factory _Spaces.fromJson(Map<String, dynamic> json) = _$SpacesImpl.fromJson;

  @override
  int? get id;
  @override
  String get title;
  @override
  DateTime? get updatedAt;
  @override
  String? get color;
  @override
  List<Tasks>? get tasks;
  @override
  List<Categories>? get categories;
  @override
  @JsonKey(ignore: true)
  _$$SpacesImplCopyWith<_$SpacesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
