// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_search_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserSearchResult _$UserSearchResultFromJson(Map<String, dynamic> json) =>
    _UserSearchResult(
      userId: json['userId'] as String,
      username: json['username'] as String,
      status: json['status'] as String?,
      sent: json['sent'] as bool?,
    );

Map<String, dynamic> _$UserSearchResultToJson(_UserSearchResult instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'username': instance.username,
      'status': instance.status,
      'sent': instance.sent,
    };
