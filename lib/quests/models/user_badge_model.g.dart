// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_badge_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserBadge _$UserBadgeFromJson(Map<String, dynamic> json) => _UserBadge(
      id: (json['id'] as num).toInt(),
      progress: (json['progress'] as num).toInt(),
      monthYear: json['monthYear'] as String,
      badge: Badge.fromJson(json['badge'] as Map<String, dynamic>),
      redeemed: json['redeemed'] as bool? ?? false,
      earnedAt: json['earnedAt'] as String?,
      redemptionCount: (json['redemptionCount'] as num).toInt(),
    );

Map<String, dynamic> _$UserBadgeToJson(_UserBadge instance) =>
    <String, dynamic>{
      'id': instance.id,
      'progress': instance.progress,
      'monthYear': instance.monthYear,
      'badge': instance.badge,
      'redeemed': instance.redeemed,
      'earnedAt': instance.earnedAt,
      'redemptionCount': instance.redemptionCount,
    };
