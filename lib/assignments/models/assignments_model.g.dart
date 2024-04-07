// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assignments_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AssignmentImpl _$$AssignmentImplFromJson(Map<String, dynamic> json) =>
    _$AssignmentImpl(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      completed: json['completed'] as bool,
      starred: json['starred'] as bool,
      deleted: json['deleted'] as bool,
    );

Map<String, dynamic> _$$AssignmentImplToJson(_$AssignmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'dueDate': instance.dueDate.toIso8601String(),
      'completed': instance.completed,
      'starred': instance.starred,
      'deleted': instance.deleted,
    };
