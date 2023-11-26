import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:uuid/uuid.dart';

part 'temp_form_process_request.g.dart';

@immutable
@JsonSerializable()
class TempFormProcessRequest {
  TempFormProcessRequest({
    required this.jobTempId,
    required this.action,
    required this.note,
    String? requestId,
    int? requestTime,
  })  : requestId = const Uuid().v4(),
        requestTime = DateTime.now().millisecondsSinceEpoch;

  @JsonKey(name: "jobTempId")
  final String jobTempId;
  @JsonKey(name: "action")
  final TempFormAction action;
  @JsonKey(name: "note")
  final String note;
  @JsonKey(name: "requestId")
  final String requestId;
  @JsonKey(name: "requestTime")
  final int requestTime;

  factory TempFormProcessRequest.fromJson(Map<String, dynamic> json) =>
      _$TempFormProcessRequestFromJson(json);

  Map<String, dynamic> toJson() => _$TempFormProcessRequestToJson(this);
}

// ignore: constant_identifier_names
enum TempFormAction { APPROVAL, REJECT }
