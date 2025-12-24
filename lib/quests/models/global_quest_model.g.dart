// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_quest_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GlobalQuest _$GlobalQuestFromJson(Map<String, dynamic> json) => _GlobalQuest(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      goalValue: (json['goalValue'] as num).toInt(),
      currentValue: (json['currentValue'] as num).toInt(),
      participantCount: (json['participantCount'] as num).toInt(),
      rewardPoints: (json['rewardPoints'] as num).toInt(),
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      completed: json['completed'] as bool? ?? false,
    );

Map<String, dynamic> _$GlobalQuestToJson(_GlobalQuest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'goalValue': instance.goalValue,
      'currentValue': instance.currentValue,
      'participantCount': instance.participantCount,
      'rewardPoints': instance.rewardPoints,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'completed': instance.completed,
    };
