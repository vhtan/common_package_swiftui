import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:uuid/uuid.dart';

part 'temp_form_process_request.g.dart';

@immutable
@JsonSerializable()
class TempFormProcessRequest {
  TempFormProcessRequest({
    required this.id,
    required this.action,
    required this.message,
    String? requestId,
    int? requestTime,
  })  : requestId = const Uuid().v4(),
        requestTime = DateTime.now().millisecondsSinceEpoch;

  @JsonKey(name: "id")
  final String id;
  @JsonKey(name: "action")
  final String action;
  @JsonKey(name: "message")
  final String message;
  @JsonKey(name: "requestId")
  final String requestId;
  @JsonKey(name: "requestTime")
  final int requestTime;

  factory TempFormProcessRequest.fromJson(Map<String, dynamic> json) =>
      _$TempFormProcessRequestFromJson(json);

  Map<String, dynamic> toJson() => _$TempFormProcessRequestToJson(this);
}
