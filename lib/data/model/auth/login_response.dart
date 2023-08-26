import 'package:freezed_annotation/freezed_annotation.dart';
part 'login_response.g.dart';
part 'login_response.freezed.dart';

@freezed
abstract class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    String? code,
    int? responseTime,
    String? session,
    String? username,
    String? password,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}
