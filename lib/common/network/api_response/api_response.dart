import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mvvm_cubit/common/network/api_error.dart';

part 'api_response.g.dart';
part 'api_response.freezed.dart';

@freezed
abstract class ApiResponse with _$ApiResponse {
  factory ApiResponse({
    ErrorCode? code,
    int? responseTime,
    dynamic detail,
  }) = _ApiResponse;

  factory ApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseFromJson(json);
}
