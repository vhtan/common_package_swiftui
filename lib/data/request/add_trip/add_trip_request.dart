import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:uuid/uuid.dart';

part 'add_trip_request.g.dart';

@immutable
@JsonSerializable()
class AddTripRequest {
  AddTripRequest({
    required this.purposeId,
    required this.stopPointAddress,
    required this.latitude,
    required this.longitude,
    required this.quantity,
    required this.currency,
    required this.driverId,
    required this.bodyguardId,
    required this.vehicleId,
    required this.note,
    String? requestId,
    int? requestTime,
  })  : requestId = const Uuid().v4(),
        requestTime = DateTime.now().millisecondsSinceEpoch;

  @JsonKey(name: "purposeId")
  final String purposeId;
  @JsonKey(name: "stopPointAddress")
  final String stopPointAddress;
  @JsonKey(name: "latitude")
  final double latitude;
  @JsonKey(name: "longitude")
  final double longitude;
  @JsonKey(name: "quantity")
  final double quantity;
  @JsonKey(name: "currency")
  final String currency;
  @JsonKey(name: "driverId")
  final String driverId;
  @JsonKey(name: "bodyguardId")
  final String bodyguardId;
  @JsonKey(name: "vehicleId")
  final String vehicleId;
  @JsonKey(name: "note")
  final String note;
  @JsonKey(name: "requestId")
  final String requestId;
  @JsonKey(name: "requestTime")
  final int requestTime;

  factory AddTripRequest.fromJson(Map<String, dynamic> json) =>
      _$AddTripRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AddTripRequestToJson(this);
}

@immutable
@JsonSerializable()
class HandleTempFormRequest {
  HandleTempFormRequest({
    required this.action,
    this.note,
    String? requestId,
    int? requestTime,
  })  : requestId = const Uuid().v4(),
        requestTime = DateTime.now().millisecondsSinceEpoch;

  @JsonKey(name: "action")
  final String action;
  @JsonKey(name: "note")
  final String? note;
  @JsonKey(name: "requestId")
  final String requestId;
  @JsonKey(name: "requestTime")
  final int requestTime;

  factory HandleTempFormRequest.fromJson(Map<String, dynamic> json) =>
      _$HandleTempFormRequestFromJson(json);

  Map<String, dynamic> toJson() => _$HandleTempFormRequestToJson(this);
}
