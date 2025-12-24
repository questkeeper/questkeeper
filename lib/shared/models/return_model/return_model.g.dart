// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'return_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReturnModel _$ReturnModelFromJson(Map<String, dynamic> json) => _ReturnModel(
      message: json['message'] as String,
      success: json['success'] as bool,
      data: json['data'],
      error: json['error'] as String?,
    );

Map<String, dynamic> _$ReturnModelToJson(_ReturnModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'success': instance.success,
      'data': instance.data,
      'error': instance.error,
    };
