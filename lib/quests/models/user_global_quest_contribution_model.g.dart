// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_global_quest_contribution_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserGlobalQuestContribution _$UserGlobalQuestContributionFromJson(
        Map<String, dynamic> json) =>
    _UserGlobalQuestContribution(
      id: (json['id'] as num).toInt(),
      globalQuestId: json['globalQuestId'] as String,
      contributionValue: (json['contributionValue'] as num).toInt(),
      lastContributedAt: json['lastContributedAt'] as String,
    );

Map<String, dynamic> _$UserGlobalQuestContributionToJson(
        _UserGlobalQuestContribution instance) =>
    <String, dynamic>{
      'id': instance.id,
      'globalQuestId': instance.globalQuestId,
      'contributionValue': instance.contributionValue,
      'lastContributedAt': instance.lastContributedAt,
    };
