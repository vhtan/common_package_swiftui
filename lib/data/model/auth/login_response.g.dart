// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginResponseImpl _$$LoginResponseImplFromJson(Map<String, dynamic> json) =>
    _$LoginResponseImpl(
      code: json['code'] as String?,
      responseTime: json['responseTime'] as int?,
      session: json['session'] as String?,
      username: json['username'] as String?,
      password: json['password'] as String?,
    );

Map<String, dynamic> _$$LoginResponseImplToJson(_$LoginResponseImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'responseTime': instance.responseTime,
      'session': instance.session,
      'username': instance.username,
      'password': instance.password,
    };
