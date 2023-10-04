import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:uuid/uuid.dart';

part 'login_request.g.dart';

@immutable
@JsonSerializable()
class LoginRequest {
  LoginRequest({
    required this.username,
    required this.password,
    String? requestId,
    int? requestTime,
  })  : requestId = const Uuid().v4(),
        requestTime = DateTime.now().millisecondsSinceEpoch;

  @JsonKey(name: "username")
  final String username;
  @JsonKey(name: "password")
  final String password;
  @JsonKey(name: "requestId")
  final String requestId;
  @JsonKey(name: "requestTime")
  final int requestTime;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
