// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spaces_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SpacesImpl _$$SpacesImplFromJson(Map<String, dynamic> json) => _$SpacesImpl(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      color: json['color'] as String?,
      tasks: (json['tasks'] as List<dynamic>?)
          ?.map((e) => Tasks.fromJson(e as Map<String, dynamic>))
          .toList(),
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => Categories.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$SpacesImplToJson(_$SpacesImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'color': instance.color,
      'tasks': instance.tasks,
      'categories': instance.categories,
    };
