import 'package:freezed_annotation/freezed_annotation.dart';
part 'purpose_response.g.dart';
part 'purpose_response.freezed.dart';

@freezed
abstract class PurposeResponse with _$PurposeResponse {
  const factory PurposeResponse({
    String? id,
    String? name,
  }) = _PurposeResponse;

  factory PurposeResponse.fromJson(Map<String, dynamic> json) =>
      _$PurposeResponseFromJson(json);
}

List<PurposeResponse> parsePurposeResponseList(List<dynamic> parsedList) {
  return parsedList
      .map((json) => PurposeResponse.fromJson(json as Map<String, dynamic>))
      .toList();
}
