// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginResponseImpl _$$LoginResponseImplFromJson(Map<String, dynamic> json) =>
    _$LoginResponseImpl(
      session: json['session'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      role: json['role'] == null
          ? null
          : RoleResponse.fromJson(json['role'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$LoginResponseImplToJson(_$LoginResponseImpl instance) =>
    <String, dynamic>{
      'session': instance.session,
      'name': instance.name,
      'email': instance.email,
      'role': instance.role,
    };

_$RoleResponseImpl _$$RoleResponseImplFromJson(Map<String, dynamic> json) =>
    _$RoleResponseImpl(
      name: json['name'] as String?,
      code: json['code'] as String?,
    );

Map<String, dynamic> _$$RoleResponseImplToJson(_$RoleResponseImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'code': instance.code,
    };
