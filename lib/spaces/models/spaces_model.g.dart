// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spaces_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Spaces _$SpacesFromJson(Map<String, dynamic> json) => _Spaces(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      spaceType: json['spaceType'] as String,
      notificationTimes:
          (json['notificationTimes'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k, (e as List<dynamic>).map((e) => (e as num).toInt()).toList()),
      ),
    );

Map<String, dynamic> _$SpacesToJson(_Spaces instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'spaceType': instance.spaceType,
      'notificationTimes': instance.notificationTimes,
    };
