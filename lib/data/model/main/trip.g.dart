// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Trip _$TripFromJson(Map<String, dynamic> json) => Trip(
      title: json['title'] as String,
      duties: (json['duties'] as List<dynamic>)
          .map((e) => PickUpDuty.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TripToJson(Trip instance) => <String, dynamic>{
      'title': instance.title,
      'duties': instance.duties,
    };
