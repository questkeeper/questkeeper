// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Profile _$ProfileFromJson(Map<String, dynamic> json) => _Profile(
      user_id: json['user_id'] as String,
      username: json['username'] as String,
      created_at: json['created_at'] as String,
      updated_at: json['updated_at'] as String,
      points: (json['points'] as num).toInt(),
      isActive: json['isActive'] as bool,
      isPublic: json['isPublic'] as bool,
      isPro: json['isPro'] as bool?,
    );

Map<String, dynamic> _$ProfileToJson(_Profile instance) => <String, dynamic>{
      'user_id': instance.user_id,
      'username': instance.username,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'points': instance.points,
      'isActive': instance.isActive,
      'isPublic': instance.isPublic,
      'isPro': instance.isPro,
    };
