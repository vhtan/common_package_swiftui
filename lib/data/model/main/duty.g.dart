// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'duty.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PickUpDuty _$PickUpDutyFromJson(Map<String, dynamic> json) => PickUpDuty(
      id: json['id'] as int,
      title: json['title'] as String,
      buttonTitle: json['buttonTitle'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
    );

Map<String, dynamic> _$PickUpDutyToJson(PickUpDuty instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'buttonTitle': instance.buttonTitle,
      'name': instance.name,
      'address': instance.address,
      'phone': instance.phone,
    };

DeliveryDuty _$DeliveryDutyFromJson(Map<String, dynamic> json) => DeliveryDuty(
      id: json['id'] as int,
      title: json['title'] as String,
      buttonTitle: json['buttonTitle'] as String,
      requestFormId: json['requestFormId'] as String,
      totalAmount: json['totalAmount'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$DeliveryDutyToJson(DeliveryDuty instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'buttonTitle': instance.buttonTitle,
      'requestFormId': instance.requestFormId,
      'totalAmount': instance.totalAmount,
      'type': instance.type,
    };
