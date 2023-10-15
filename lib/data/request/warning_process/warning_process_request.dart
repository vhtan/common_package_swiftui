import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:uuid/uuid.dart';

part 'warning_process_request.g.dart';

@immutable
@JsonSerializable()
class WarningProcessRequest {
  WarningProcessRequest({
    required this.warningId,
    required this.action,
    required this.message,
    String? requestId,
    int? requestTime,
  })  : requestId = const Uuid().v4(),
        requestTime = DateTime.now().millisecondsSinceEpoch;

  @JsonKey(name: "warningId")
  final String warningId;
  @JsonKey(name: "action")
  final String action;
  @JsonKey(name: "message")
  final String message;
  @JsonKey(name: "requestId")
  final String requestId;
  @JsonKey(name: "requestTime")
  final int requestTime;

  factory WarningProcessRequest.fromJson(Map<String, dynamic> json) =>
      _$WarningProcessRequestFromJson(json);

  Map<String, dynamic> toJson() => _$WarningProcessRequestToJson(this);
}
