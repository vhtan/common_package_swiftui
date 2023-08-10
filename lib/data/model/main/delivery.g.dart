// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Delivery _$DeliveryFromJson(Map<String, dynamic> json) => Delivery(
      id: json['id'] as int?,
      orderCode: json['orderCode'] as String,
      startAddress: json['startAddress'] as String,
      destinationAddress: json['destinationAddress'] as String,
      startedTime: DateTime.parse(json['startedTime'] as String),
      status: $enumDecode(_$DeliveryStatusEnumMap, json['status']),
      type: $enumDecode(_$DeliveryTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$DeliveryToJson(Delivery instance) => <String, dynamic>{
      'id': instance.id,
      'orderCode': instance.orderCode,
      'startAddress': instance.startAddress,
      'destinationAddress': instance.destinationAddress,
      'startedTime': instance.startedTime.toIso8601String(),
      'status': _$DeliveryStatusEnumMap[instance.status]!,
      'type': _$DeliveryTypeEnumMap[instance.type]!,
    };

const _$DeliveryStatusEnumMap = {
  DeliveryStatus.ready: 'ready',
  DeliveryStatus.notStarted: 'notStarted',
  DeliveryStatus.arrived: 'arrived',
  DeliveryStatus.finished: 'finished',
  DeliveryStatus.completed: 'completed',
  DeliveryStatus.missingInfo: 'missingInfo',
};

const _$DeliveryTypeEnumMap = {
  DeliveryType.increaseFund: 'increaseFund',
  DeliveryType.decreaseFund: 'decreaseFund',
  DeliveryType.goOnBussiness: 'goOnBussiness',
};
