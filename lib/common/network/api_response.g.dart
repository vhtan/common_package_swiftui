// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApiResponseImpl _$$ApiResponseImplFromJson(Map<String, dynamic> json) =>
    _$ApiResponseImpl(
      code: $enumDecodeNullable(_$ErrorCodeEnumMap, json['code']),
      responseTime: json['responseTime'] as int?,
      detail: json['detail'],
    );

Map<String, dynamic> _$$ApiResponseImplToJson(_$ApiResponseImpl instance) =>
    <String, dynamic>{
      'code': _$ErrorCodeEnumMap[instance.code],
      'responseTime': instance.responseTime,
      'detail': instance.detail,
    };

const _$ErrorCodeEnumMap = {
  ErrorCode.SUCCESS: 'SUCCESS',
  ErrorCode.ERROR: 'ERROR',
  ErrorCode.BAD_REQUEST: 'BAD_REQUEST',
  ErrorCode.DOCUMENT_NOT_FOUND: 'DOCUMENT_NOT_FOUND',
  ErrorCode.AUTHENTICATION_FAIL: 'AUTHENTICATION_FAIL',
  ErrorCode.USER_NOT_FOUND: 'USER_NOT_FOUND',
  ErrorCode.NONE_UNIQUE_CONSTRAIN: 'NONE_UNIQUE_CONSTRAIN',
  ErrorCode.MAX_SIZE_EXCEED: 'MAX_SIZE_EXCEED',
  ErrorCode.FILE_NOT_SUPPORT: 'FILE_NOT_SUPPORT',
  ErrorCode.PERMISSION_DENIED: 'PERMISSION_DENIED',
};
