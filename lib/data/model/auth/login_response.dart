import 'package:freezed_annotation/freezed_annotation.dart';
part 'login_response.g.dart';
part 'login_response.freezed.dart';

@freezed
abstract class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    String? session,
    String? name,
    String? email,
    RoleResponse? role,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  factory LoginResponse.fromJson1(Map<String, dynamic> json) {
    throw UnimplementedError();
  }
}

@freezed
abstract class RoleResponse with _$RoleResponse {
  const factory RoleResponse({
    String? name,
    String? code,
  }) = _RoleResponse;

  factory RoleResponse.fromJson(Map<String, dynamic> json) =>
      _$RoleResponseFromJson(json);
}
