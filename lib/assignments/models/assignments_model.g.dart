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
      completed: json['completed'] as bool? ?? false,
      starred: json['starred'] as bool? ?? false,
      deleted: json['deleted'] as bool? ?? false,
    );

Map<String, dynamic> _$$AssignmentImplToJson(_$AssignmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'title': instance.title,
      'dueDate': instance.dueDate.toIso8601String(),
      'description': instance.description,
      'completed': instance.completed,
      'starred': instance.starred,
      'deleted': instance.deleted,
    };
