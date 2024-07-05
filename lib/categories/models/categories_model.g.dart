// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categories_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoriesImpl _$$CategoriesImplFromJson(Map<String, dynamic> json) =>
    _$CategoriesImpl(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      color: json['color'] as String?,
      spaceId: (json['spaceId'] as num?)?.toInt(),
      archived: json['archived'] as bool? ?? false,
      tasks: (json['tasks'] as List<dynamic>?)
          ?.map((e) => Tasks.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$CategoriesImplToJson(_$CategoriesImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'color': instance.color,
      'spaceId': instance.spaceId,
      'archived': instance.archived,
      'tasks': instance.tasks,
    };
