// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subtasks_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SubtaskImpl _$$SubtaskImplFromJson(Map<String, dynamic> json) =>
    _$SubtaskImpl(
      id: json['id'] as int?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      title: json['title'] as String,
      assignmentId: json['assignmentId'] as int,
      priority: json['priority'] as int?,
      completed: json['completed'] as bool? ?? false,
    );

Map<String, dynamic> _$$SubtaskImplToJson(_$SubtaskImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'title': instance.title,
      'assignmentId': instance.assignmentId,
      'priority': instance.priority,
      'completed': instance.completed,
    };
