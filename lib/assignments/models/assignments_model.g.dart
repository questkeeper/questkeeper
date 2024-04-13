// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assignments_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AssignmentImpl _$$AssignmentImplFromJson(Map<String, dynamic> json) =>
    _$AssignmentImpl(
      id: json['id'] as int?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      title: json['title'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      description: json['description'] as String?,
      subjectId: json['subjectId'] as int?,
      subject: json['subject'] == null
          ? null
          : Subject.fromJson(json['subject'] as Map<String, dynamic>),
      completed: json['completed'] as bool? ?? false,
      starred: json['starred'] as bool? ?? false,
      deleted: json['deleted'] as bool? ?? false,
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$CategoriesEnumMap, e))
              .toList() ??
          const [Categories.homework],
    );

Map<String, dynamic> _$$AssignmentImplToJson(_$AssignmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'title': instance.title,
      'dueDate': instance.dueDate.toIso8601String(),
      'description': instance.description,
      'subjectId': instance.subjectId,
      'subject': instance.subject,
      'completed': instance.completed,
      'starred': instance.starred,
      'deleted': instance.deleted,
      'categories':
          instance.categories?.map((e) => _$CategoriesEnumMap[e]!).toList(),
    };

const _$CategoriesEnumMap = {
  Categories.homework: 'homework',
  Categories.quiz: 'quiz',
  Categories.essay: 'essay',
  Categories.exam: 'exam',
  Categories.project: 'project',
  Categories.presentation: 'presentation',
};
