// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_LoginResponse _$$_LoginResponseFromJson(Map<String, dynamic> json) =>
    _$_LoginResponse(
      code: json['code'] as String?,
      responseTime: json['responseTime'] as int?,
      session: json['session'] as String?,
      username: json['username'] as String?,
      password: json['password'] as String?,
    );

Map<String, dynamic> _$$_LoginResponseToJson(_$_LoginResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'responseTime': instance.responseTime,
      'session': instance.session,
      'username': instance.username,
      'password': instance.password,
    };
