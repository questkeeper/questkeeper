// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subtasks_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Subtask _$SubtaskFromJson(Map<String, dynamic> json) => _Subtask(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String,
      priority: (json['priority'] as num?)?.toInt() ?? 1,
      completed: json['completed'] as bool? ?? false,
      taskId: (json['taskId'] as num).toInt(),
    );

Map<String, dynamic> _$SubtaskToJson(_Subtask instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'priority': instance.priority,
      'completed': instance.completed,
      'taskId': instance.taskId,
    };
