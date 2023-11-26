import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
part 'login_response.g.dart';
part 'login_response.freezed.dart';

@HiveType(typeId: 0)
@freezed
abstract class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    String? session,
    @HiveField(0) String? name,
    @HiveField(1) String? email,
    @HiveField(2) RoleResponse? role,
    @HiveField(3) double? arrivalLimitRadius,
    @HiveField(4) String? code,
    @HiveField(5) bool? manager,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  factory LoginResponse.fromJson1(Map<String, dynamic> json) {
    throw UnimplementedError();
  }
}

@HiveType(typeId: 0)
@freezed
abstract class RoleResponse with _$RoleResponse {
  const factory RoleResponse({
    @HiveField(0) String? name,
    @HiveField(1) String? code,
  }) = _RoleResponse;

  factory RoleResponse.fromJson(Map<String, dynamic> json) =>
      _$RoleResponseFromJson(json);
}
