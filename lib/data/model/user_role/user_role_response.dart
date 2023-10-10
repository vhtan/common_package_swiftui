import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_role_response.g.dart';
part 'user_role_response.freezed.dart';

@freezed
abstract class UserRoleResponse with _$UserRoleResponse {
  const factory UserRoleResponse({
    String? id,
    String? name,
    String? phone,
    String? email,
  }) = _UserRoleResponse;

  factory UserRoleResponse.fromJson(Map<String, dynamic> json) =>
      _$UserRoleResponseFromJson(json);
}

List<UserRoleResponse> userRoleResponseList(List<dynamic> parsedList) {
  return parsedList
      .map((json) => UserRoleResponse.fromJson(json as Map<String, dynamic>))
      .toList();
}
