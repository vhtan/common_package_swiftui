// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Delivery _$DeliveryFromJson(Map<String, dynamic> json) => Delivery(
      id: json['id'] as int?,
      name: json['name'] as String,
      email: json['email'] as String,
      status: $enumDecode(_$DeliveryStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$DeliveryToJson(Delivery instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'status': _$DeliveryStatusEnumMap[instance.status]!,
    };

const _$DeliveryStatusEnumMap = {
  DeliveryStatus.ready: 'ready',
  DeliveryStatus.notStarted: 'notStarted',
  DeliveryStatus.arrived: 'arrived',
  DeliveryStatus.finished: 'finished',
  DeliveryStatus.completed: 'completed',
  DeliveryStatus.missingInfo: 'missingInfo',
};
