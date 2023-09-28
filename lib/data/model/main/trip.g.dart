// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Trip _$TripFromJson(Map<String, dynamic> json) => Trip(
      reason: json['reason'] as String?,
      stopPlace: json['stopPlace'] as String?,
      amount: json['amount'] as int?,
      vehicle: json['vehicle'] as String?,
      guard: json['guard'] as String?,
      licensePlates: json['licensePlates'] as String?,
    );

Map<String, dynamic> _$TripToJson(Trip instance) => <String, dynamic>{
      'reason': instance.reason,
      'stopPlace': instance.stopPlace,
      'amount': instance.amount,
      'vehicle': instance.vehicle,
      'guard': instance.guard,
      'licensePlates': instance.licensePlates,
    };
