// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Friend _$FriendFromJson(Map<String, dynamic> json) => _Friend(
      userId: json['userId'] as String,
      username: json['username'] as String,
      points: (json['points'] as num).toInt(),
    );

Map<String, dynamic> _$FriendToJson(_Friend instance) => <String, dynamic>{
      'userId': instance.userId,
      'username': instance.username,
      'points': instance.points,
    };
