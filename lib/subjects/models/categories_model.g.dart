// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categories_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoriesImpl _$$CategoriesImplFromJson(Map<String, dynamic> json) =>
    _$CategoriesImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      $createdAt: json[r'$createdAt'] == null
          ? null
          : DateTime.parse(json[r'$createdAt'] as String),
      $updatedAt: json[r'$updatedAt'] == null
          ? null
          : DateTime.parse(json[r'$updatedAt'] as String),
      color: json['color'] as String?,
      spaceId: (json['spaceId'] as num?)?.toInt(),
      archived: json['archived'] as bool? ?? false,
    );

Map<String, dynamic> _$$CategoriesImplToJson(_$CategoriesImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      r'$createdAt': instance.$createdAt?.toIso8601String(),
      r'$updatedAt': instance.$updatedAt?.toIso8601String(),
      'color': instance.color,
      'spaceId': instance.spaceId,
      'archived': instance.archived,
    };
