// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subjects_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SubjectImpl _$$SubjectImplFromJson(Map<String, dynamic> json) =>
    _$SubjectImpl(
      $id: json[r'$id'] as String,
      name: json['name'] as String,
      $createdAt: json[r'$createdAt'] == null
          ? null
          : DateTime.parse(json[r'$createdAt'] as String),
      $updatedAt: json[r'$updatedAt'] == null
          ? null
          : DateTime.parse(json[r'$updatedAt'] as String),
      color: json['color'] as String?,
      assignments: (json['assignments'] as List<dynamic>?)
          ?.map((e) => Assignment.fromJson(e as Map<String, dynamic>))
          .toList(),
      archived: json['archived'] as bool? ?? false,
    );

Map<String, dynamic> _$$SubjectImplToJson(_$SubjectImpl instance) =>
    <String, dynamic>{
      r'$id': instance.$id,
      'name': instance.name,
      r'$createdAt': instance.$createdAt?.toIso8601String(),
      r'$updatedAt': instance.$updatedAt?.toIso8601String(),
      'color': instance.color,
      'assignments': instance.assignments,
      'archived': instance.archived,
    };
