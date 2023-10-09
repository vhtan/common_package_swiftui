import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:uuid/uuid.dart';

part 'task_purpose_request.g.dart';

@immutable
@JsonSerializable()
class TaskPurposeRequest {
  TaskPurposeRequest({
    required this.roles,
    String? requestId,
    int? requestTime,
  })  : requestId = const Uuid().v4(),
        requestTime = DateTime.now().millisecondsSinceEpoch;

  @JsonKey(name: "roles")
  final List<String> roles;
  @JsonKey(name: "requestId")
  final String requestId;
  @JsonKey(name: "requestTime")
  final int requestTime;

  factory TaskPurposeRequest.fromJson(Map<String, dynamic> json) =>
      _$TaskPurposeRequestFromJson(json);

  Map<String, dynamic> toJson() => _$TaskPurposeRequestToJson(this);
}
