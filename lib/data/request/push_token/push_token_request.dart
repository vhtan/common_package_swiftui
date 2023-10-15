import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:uuid/uuid.dart';

part 'push_token_request.g.dart';

@immutable
@JsonSerializable()
class PushTokenRequest {
  PushTokenRequest({
    required this.deviceToken,
    String? requestId,
    int? requestTime,
  })  : requestId = const Uuid().v4(),
        requestTime = DateTime.now().millisecondsSinceEpoch;

  @JsonKey(name: "deviceToken")
  final String deviceToken;
  @JsonKey(name: "requestId")
  final String requestId;
  @JsonKey(name: "requestTime")
  final int requestTime;

  factory PushTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$PushTokenRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PushTokenRequestToJson(this);
}
