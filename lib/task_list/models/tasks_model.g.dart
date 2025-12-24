// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Tasks _$TasksFromJson(Map<String, dynamic> json) => _Tasks(
      id: (json['id'] as num?)?.toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      title: json['title'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      categoryId: (json['categoryId'] as num?)?.toInt(),
      spaceId: (json['spaceId'] as num?)?.toInt(),
      description: json['description'] as String?,
      completed: json['completed'] as bool? ?? false,
      starred: json['starred'] as bool? ?? false,
    );

Map<String, dynamic> _$TasksToJson(_Tasks instance) => <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'title': instance.title,
      'dueDate': instance.dueDate.toIso8601String(),
      'categoryId': instance.categoryId,
      'spaceId': instance.spaceId,
      'description': instance.description,
      'completed': instance.completed,
      'starred': instance.starred,
    };
