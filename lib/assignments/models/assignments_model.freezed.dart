// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assignments_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Assignment _$AssignmentFromJson(Map<String, dynamic> json) {
  return _Assignment.fromJson(json);
}

/// @nodoc
mixin _$Assignment {
  String get $id => throw _privateConstructorUsedError;
  DateTime? get $createdAt => throw _privateConstructorUsedError;
  DateTime? get $updatedAt => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  DateTime get dueDate => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  Subject? get subject => throw _privateConstructorUsedError;
  List<Subtask>? get subtasks => throw _privateConstructorUsedError;
  bool get completed => throw _privateConstructorUsedError;
  bool get starred => throw _privateConstructorUsedError;
  List<Categories> get categories => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AssignmentCopyWith<Assignment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssignmentCopyWith<$Res> {
  factory $AssignmentCopyWith(
          Assignment value, $Res Function(Assignment) then) =
      _$AssignmentCopyWithImpl<$Res, Assignment>;
  @useResult
  $Res call(
      {String $id,
      DateTime? $createdAt,
      DateTime? $updatedAt,
      String title,
      DateTime dueDate,
      String? description,
      Subject? subject,
      List<Subtask>? subtasks,
      bool completed,
      bool starred,
      List<Categories> categories});

  $SubjectCopyWith<$Res>? get subject;
}

/// @nodoc
class _$AssignmentCopyWithImpl<$Res, $Val extends Assignment>
    implements $AssignmentCopyWith<$Res> {
  _$AssignmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? $id = null,
    Object? $createdAt = freezed,
    Object? $updatedAt = freezed,
    Object? title = null,
    Object? dueDate = null,
    Object? description = freezed,
    Object? subject = freezed,
    Object? subtasks = freezed,
    Object? completed = null,
    Object? starred = null,
    Object? categories = null,
  }) {
    return _then(_value.copyWith(
      $id: null == $id
          ? _value.$id
          : $id // ignore: cast_nullable_to_non_nullable
              as String,
      $createdAt: freezed == $createdAt
          ? _value.$createdAt
          : $createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      $updatedAt: freezed == $updatedAt
          ? _value.$updatedAt
          : $updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      dueDate: null == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      subject: freezed == subject
          ? _value.subject
          : subject // ignore: cast_nullable_to_non_nullable
              as Subject?,
      subtasks: freezed == subtasks
          ? _value.subtasks
          : subtasks // ignore: cast_nullable_to_non_nullable
              as List<Subtask>?,
      completed: null == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool,
      starred: null == starred
          ? _value.starred
          : starred // ignore: cast_nullable_to_non_nullable
              as bool,
      categories: null == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Categories>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $SubjectCopyWith<$Res>? get subject {
    if (_value.subject == null) {
      return null;
    }

    return $SubjectCopyWith<$Res>(_value.subject!, (value) {
      return _then(_value.copyWith(subject: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AssignmentImplCopyWith<$Res>
    implements $AssignmentCopyWith<$Res> {
  factory _$$AssignmentImplCopyWith(
          _$AssignmentImpl value, $Res Function(_$AssignmentImpl) then) =
      __$$AssignmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String $id,
      DateTime? $createdAt,
      DateTime? $updatedAt,
      String title,
      DateTime dueDate,
      String? description,
      Subject? subject,
      List<Subtask>? subtasks,
      bool completed,
      bool starred,
      List<Categories> categories});

  @override
  $SubjectCopyWith<$Res>? get subject;
}

/// @nodoc
class __$$AssignmentImplCopyWithImpl<$Res>
    extends _$AssignmentCopyWithImpl<$Res, _$AssignmentImpl>
    implements _$$AssignmentImplCopyWith<$Res> {
  __$$AssignmentImplCopyWithImpl(
      _$AssignmentImpl _value, $Res Function(_$AssignmentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? $id = null,
    Object? $createdAt = freezed,
    Object? $updatedAt = freezed,
    Object? title = null,
    Object? dueDate = null,
    Object? description = freezed,
    Object? subject = freezed,
    Object? subtasks = freezed,
    Object? completed = null,
    Object? starred = null,
    Object? categories = null,
  }) {
    return _then(_$AssignmentImpl(
      $id: null == $id
          ? _value.$id
          : $id // ignore: cast_nullable_to_non_nullable
              as String,
      $createdAt: freezed == $createdAt
          ? _value.$createdAt
          : $createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      $updatedAt: freezed == $updatedAt
          ? _value.$updatedAt
          : $updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      dueDate: null == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      subject: freezed == subject
          ? _value.subject
          : subject // ignore: cast_nullable_to_non_nullable
              as Subject?,
      subtasks: freezed == subtasks
          ? _value._subtasks
          : subtasks // ignore: cast_nullable_to_non_nullable
              as List<Subtask>?,
      completed: null == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool,
      starred: null == starred
          ? _value.starred
          : starred // ignore: cast_nullable_to_non_nullable
              as bool,
      categories: null == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Categories>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AssignmentImpl implements _Assignment {
  const _$AssignmentImpl(
      {required this.$id,
      this.$createdAt,
      this.$updatedAt,
      required this.title,
      required this.dueDate,
      this.description,
      this.subject,
      final List<Subtask>? subtasks,
      this.completed = false,
      this.starred = false,
      final List<Categories> categories = const [Categories.homework]})
      : _subtasks = subtasks,
        _categories = categories;

  factory _$AssignmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$AssignmentImplFromJson(json);

  @override
  final String $id;
  @override
  final DateTime? $createdAt;
  @override
  final DateTime? $updatedAt;
  @override
  final String title;
  @override
  final DateTime dueDate;
  @override
  final String? description;
  @override
  final Subject? subject;
  final List<Subtask>? _subtasks;
  @override
  List<Subtask>? get subtasks {
    final value = _subtasks;
    if (value == null) return null;
    if (_subtasks is EqualUnmodifiableListView) return _subtasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final bool completed;
  @override
  @JsonKey()
  final bool starred;
  final List<Categories> _categories;
  @override
  @JsonKey()
  List<Categories> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  @override
  String toString() {
    return 'Assignment(\$id: ${$id}, \$createdAt: ${$createdAt}, \$updatedAt: ${$updatedAt}, title: $title, dueDate: $dueDate, description: $description, subject: $subject, subtasks: $subtasks, completed: $completed, starred: $starred, categories: $categories)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssignmentImpl &&
            (identical(other.$id, $id) || other.$id == $id) &&
            (identical(other.$createdAt, $createdAt) ||
                other.$createdAt == $createdAt) &&
            (identical(other.$updatedAt, $updatedAt) ||
                other.$updatedAt == $updatedAt) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.subject, subject) || other.subject == subject) &&
            const DeepCollectionEquality().equals(other._subtasks, _subtasks) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.starred, starred) || other.starred == starred) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      $id,
      $createdAt,
      $updatedAt,
      title,
      dueDate,
      description,
      subject,
      const DeepCollectionEquality().hash(_subtasks),
      completed,
      starred,
      const DeepCollectionEquality().hash(_categories));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AssignmentImplCopyWith<_$AssignmentImpl> get copyWith =>
      __$$AssignmentImplCopyWithImpl<_$AssignmentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AssignmentImplToJson(
      this,
    );
  }
}

abstract class _Assignment implements Assignment {
  const factory _Assignment(
      {required final String $id,
      final DateTime? $createdAt,
      final DateTime? $updatedAt,
      required final String title,
      required final DateTime dueDate,
      final String? description,
      final Subject? subject,
      final List<Subtask>? subtasks,
      final bool completed,
      final bool starred,
      final List<Categories> categories}) = _$AssignmentImpl;

  factory _Assignment.fromJson(Map<String, dynamic> json) =
      _$AssignmentImpl.fromJson;

  @override
  String get $id;
  @override
  DateTime? get $createdAt;
  @override
  DateTime? get $updatedAt;
  @override
  String get title;
  @override
  DateTime get dueDate;
  @override
  String? get description;
  @override
  Subject? get subject;
  @override
  List<Subtask>? get subtasks;
  @override
  bool get completed;
  @override
  bool get starred;
  @override
  List<Categories> get categories;
  @override
  @JsonKey(ignore: true)
  _$$AssignmentImplCopyWith<_$AssignmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
