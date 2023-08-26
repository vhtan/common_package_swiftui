import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/foundation.dart' show immutable;

part 'logout_request.g.dart';

@immutable
@JsonSerializable()
class LogoutRequest {
  const LogoutRequest({
    required this.username,
  });

  @JsonKey(name: "username")
  final String username;

  factory LogoutRequest.fromJson(Map<String, dynamic> json) =>
      _$LogoutRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LogoutRequestToJson(this);
}
