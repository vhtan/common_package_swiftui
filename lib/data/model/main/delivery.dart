import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/foundation.dart' show immutable;

part 'delivery.g.dart';

@immutable
@JsonSerializable()
class Delivery {
  const Delivery({
    this.id,
    required this.name,
    required this.email,
    required this.status,
  });

  final int? id;
  final String name;
  final String email;
  @JsonKey(name: "status")
  final DeliveryStatus status;

  factory Delivery.fromJson(Map<String, dynamic> json) =>
      _$DeliveryFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryToJson(this);
}

@JsonEnum()
enum DeliveryStatus {
  ready,
  notStarted,
  arrived,
  finished,
  completed,
  missingInfo
}
