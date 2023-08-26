import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/foundation.dart' show immutable;

part 'login_request.g.dart';

@immutable
@JsonSerializable()
class LoginRequest {
  const LoginRequest({
    required this.username,
    required this.password,
    required this.requestId,
    required this.requestTime,
  });

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
