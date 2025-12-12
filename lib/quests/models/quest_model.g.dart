// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Quest _$QuestFromJson(Map<String, dynamic> json) => _Quest(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      points: (json['points'] as num).toInt(),
      requirementCount: (json['requirementCount'] as num).toInt(),
      category: json['category'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$QuestToJson(_Quest instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'points': instance.points,
      'requirementCount': instance.requirementCount,
      'category': instance.category,
      'type': instance.type,
    };
