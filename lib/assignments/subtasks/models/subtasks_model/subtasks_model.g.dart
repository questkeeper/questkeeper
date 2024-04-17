// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subtasks_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SubtaskImpl _$$SubtaskImplFromJson(Map<String, dynamic> json) =>
    _$SubtaskImpl(
      $id: json[r'$id'] as String,
      title: json['title'] as String,
      priority: json['priority'] as int? ?? 1,
      completed: json['completed'] as bool? ?? false,
    );

Map<String, dynamic> _$$SubtaskImplToJson(_$SubtaskImpl instance) =>
    <String, dynamic>{
      r'$id': instance.$id,
      'title': instance.title,
      'priority': instance.priority,
      'completed': instance.completed,
    };
