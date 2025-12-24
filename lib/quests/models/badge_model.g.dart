// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Badge _$BadgeFromJson(Map<String, dynamic> json) => _Badge(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      points: (json['points'] as num).toInt(),
      requirementCount: (json['requirementCount'] as num).toInt(),
      category: json['category'] as String,
      tier: (json['tier'] as num).toInt(),
      resetMonthly: json['resetMonthly'] as bool,
    );

Map<String, dynamic> _$BadgeToJson(_Badge instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'points': instance.points,
      'requirementCount': instance.requirementCount,
      'category': instance.category,
      'tier': instance.tier,
      'resetMonthly': instance.resetMonthly,
    };
