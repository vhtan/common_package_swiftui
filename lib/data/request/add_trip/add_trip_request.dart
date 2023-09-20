import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/foundation.dart' show immutable;

part 'add_trip_request.g.dart';

@immutable
@JsonSerializable()
class AddTripRequest {
  const AddTripRequest({
    required this.title,
  });

  @JsonKey(name: "title")
  final String title;

  factory AddTripRequest.fromJson(Map<String, dynamic> json) =>
      _$AddTripRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AddTripRequestToJson(this);
}
