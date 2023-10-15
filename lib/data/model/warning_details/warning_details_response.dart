import 'package:freezed_annotation/freezed_annotation.dart';
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
  }) = _WarningDetailsResponse;
  factory WarningDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$WarningDetailsResponseFromJson(json);
}

@freezed
abstract class PicUserResponse with _$PicUserResponse {
  const factory PicUserResponse({
    String? id,
    String? phone,
    String? username,
    String? name,
    String? email,
  }) = _PicUserResponse;
  factory PicUserResponse.fromJson(Map<String, dynamic> json) =>
      _$PicUserResponseFromJson(json);
}
