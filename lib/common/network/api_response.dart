import 'package:freezed_annotation/freezed_annotation.dart';
// part 'api_response.freezed.dart';

// @freezed
// @JsonSerializable(genericArgumentFactories: true)
// abstract class ApiResponse<T> with _$ApiResponse<T> {
//   factory ApiResponse({
//     String? code,
//     int? responseTime,
//     T? detail,
//   }) = _ApiResponse<T>;

//   factory ApiResponse.fromJson(Map<String, dynamic> json) =>
//       _$ApiResponseFromJson(json);
// }

class ApiResponse<T> {
  final String code;
  final T? detail;

  ApiResponse({
    required this.code,
    required this.detail,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return ApiResponse(
      code: json['code'] as String,
      detail: fromJsonT(json['detail']),
    );
  }
}
