// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_badges_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FriendBadgesProfileModel _$FriendBadgesProfileModelFromJson(
        Map<String, dynamic> json) =>
    _FriendBadgesProfileModel(
      badges: (json['badges'] as List<dynamic>)
          .map((e) => UserBadge.fromJson(e as Map<String, dynamic>))
          .toList(),
      stats: json['stats'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$FriendBadgesProfileModelToJson(
        _FriendBadgesProfileModel instance) =>
    <String, dynamic>{
      'badges': instance.badges,
      'stats': instance.stats,
    };
