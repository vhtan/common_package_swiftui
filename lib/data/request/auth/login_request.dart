import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/foundation.dart' show immutable;

part 'login_request.g.dart';

@immutable
@JsonSerializable()
class LoginRequest {
  const LoginRequest({
    this.id,
    required this.userId,
    required this.title,
    required this.dueOn,
  });

  final int? id;
  @JsonKey(name: "user_id")
  final int userId;
  final String title;
  @JsonKey(name: "due_on")
  final DateTime dueOn;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
