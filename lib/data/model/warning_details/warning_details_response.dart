import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mvvm_cubit/data/model/auth/login_response.dart';
part 'warning_details_response.g.dart';
part 'warning_details_response.freezed.dart';

@freezed
abstract class WarningDetailsResponse with _$WarningDetailsResponse {
  const factory WarningDetailsResponse({
    String? id,
    String? type,
    double? distance,
    int? level,
    String? warningMessage,
    PicUserResponse? acceptedUser,
    PicUserResponse? pic,
    PicUserResponse? warnedUser,
    int? startTime,
    String? startAddress,
    int? endTime,
    String? endAddress,
    double? startLatitude,
    double? startLongitude,
    double? endLatitude,
    double? endLongitude,
    int? status,
  }) = _WarningDetailsResponse;
  factory WarningDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$WarningDetailsResponseFromJson(json);
}

List<WarningDetailsResponse> parseWarningDetailsResponseList(
    List<dynamic> parsedList) {
  return parsedList
      .map((json) =>
          WarningDetailsResponse.fromJson(json as Map<String, dynamic>))
      .toList();
}

@freezed
abstract class PicUserResponse with _$PicUserResponse {
  const factory PicUserResponse({
    String? id,
    String? phone,
    String? username,
    String? name,
    String? email,
    int? dateCreated,
    RoleResponse? role,
  }) = _PicUserResponse;
  factory PicUserResponse.fromJson(Map<String, dynamic> json) =>
      _$PicUserResponseFromJson(json);
}
