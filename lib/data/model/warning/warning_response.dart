import 'package:freezed_annotation/freezed_annotation.dart';
part 'warning_response.g.dart';
part 'warning_response.freezed.dart';

@freezed
abstract class WarningResponse with _$WarningResponse {
  const factory WarningResponse({
    String? id,
    String? type,
    String? startAddress,
    String? endAddress,
    int? duration,
    double? distance,
    int? level,
    String? warningMessage,
  }) = _WarningResponse;
  factory WarningResponse.fromJson(Map<String, dynamic> json) =>
      _$WarningResponseFromJson(json);
}

List<WarningResponse> parseWarningResponseList(List<dynamic> parsedList) {
  return parsedList
      .map((json) => WarningResponse.fromJson(json as Map<String, dynamic>))
      .toList();
}
