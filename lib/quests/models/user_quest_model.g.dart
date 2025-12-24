// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_quest_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserQuest _$UserQuestFromJson(Map<String, dynamic> json) => _UserQuest(
      id: (json['id'] as num).toInt(),
      quest: Quest.fromJson(json['quest'] as Map<String, dynamic>),
      progress: (json['progress'] as num).toInt(),
      completed: json['completed'] as bool? ?? false,
      redeemed: json['redeemed'] as bool? ?? false,
      completedAt: json['completedAt'] as String?,
      assignedAt: json['assignedAt'] as String,
    );

Map<String, dynamic> _$UserQuestToJson(_UserQuest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quest': instance.quest,
      'progress': instance.progress,
      'completed': instance.completed,
      'redeemed': instance.redeemed,
      'completedAt': instance.completedAt,
      'assignedAt': instance.assignedAt,
    };
