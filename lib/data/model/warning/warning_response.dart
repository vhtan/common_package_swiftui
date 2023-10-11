import 'package:freezed_annotation/freezed_annotation.dart';
part 'warning_response.g.dart';
part 'warning_response.freezed.dart';

@freezed
abstract class WarningResponse with _$WarningResponse {
  const factory WarningResponse({
    String? id,
    String? plateNumber,
    String? description,
  }) = _WarningResponse;
  factory WarningResponse.fromJson(Map<String, dynamic> json) =>
      _$WarningResponseFromJson(json);
}
