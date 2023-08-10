import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/foundation.dart' show immutable;

part 'delivery.g.dart';

@immutable
@JsonSerializable()
class Delivery {
  const Delivery({
    this.id,
    required this.orderCode,
    required this.startAddress,
    required this.destinationAddress,
    required this.startedTime,
    required this.status,
    required this.type,
  });

  final int? id;
  final String orderCode;
  final String startAddress;
  final String destinationAddress;
  final DateTime startedTime;
  @JsonKey(name: "status")
  final DeliveryStatus status;

  @JsonKey(name: "type")
  final DeliveryType type;

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

extension DeliveryStatusExtension on DeliveryStatus {
  String get name {
    switch (this) {
      case DeliveryStatus.ready:
        return 'Sẵn sàng';
      case DeliveryStatus.notStarted:
        return 'Xuất phát';
      case DeliveryStatus.arrived:
        return 'Đến nơi';
      case DeliveryStatus.finished:
        return 'Hoàn thành';
      case DeliveryStatus.completed:
        return 'Kết thúc';
      case DeliveryStatus.missingInfo:
        return 'Thông tin chưa đầy đủ';
    }
  }
}

@JsonEnum()
enum DeliveryType { increaseFund, decreaseFund, goOnBussiness }

extension DeliveryTypeExtension on DeliveryType {
  String get name {
    switch (this) {
      case DeliveryType.increaseFund:
        return 'Thu quỹ';
      case DeliveryType.decreaseFund:
        return 'Tiếp quỹ';
      case DeliveryType.goOnBussiness:
        return 'Công tác';
    }
  }
}
